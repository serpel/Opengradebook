class SchoolReportsController < ApplicationController
  before_filter :login_required, :has_access
  #filter_access_to :all

  def has_access
    privilege = current_user.privileges.map{|p| p.name}
    unless privilege.include?("decroly_school")
      redirect_to :controller => 'user', :action => 'dashboard'
      flash[:notice] = "#{t('flash_msg4')}"
    end
  end
  # GET /school_reports
  # GET /school_reports.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def batches
    @employee = Employee.find_by_employee_number(current_user.username)
    @my_subjects = @employee.subjects.select { |s| s.is_deleted == false }
    b = @my_subjects.map { |a| a.batch_id }.uniq
    @batches = Batch.find_all_by_id(b, :conditions => { :is_deleted => false, :is_active => true })
  end

  def get_students
    parameter = params[:batch_id] == nil ? -1:params[:batch_id]
    @students = Student.find_all_by_batch_id(parameter, :order => 'gender ASC, first_name ASC')
    render(:update) { |page| page.replace_html 'students', :partial => 'students_by_course' }
  end

  require "odf-report"
  require 'string'
  def gradebook_report

    student = Student.find(params[:id])
    file_ext = params[:ext]
    grades = student.notas.select { |n| n.subject.batch == student.batch }
    personalities = student.student_grade_personalities
    total_rating = 0
    date = Time.now.strftime('%Y-%m-%d')
    pg = 'pg'

    odt_template = Rails.root.join('public/templates/decroly_boleta_calificaciones.odt')
    report = ODFReport.new(odt_template) do |r|

      r.add_field 'STUDENT', student.full_name
      r.add_field 'COURSE', student.batch.course_section_name
      r.add_field 'DATE', date
      r.add_field 'YEAR', Time.now.strftime('%Y')
      r.add_field 'DIRECTOR', 'R. Yomila A. de Aguirre'
      r.add_field 'SECRETARY', 'Manuel Vasquez'

      count = 1
      r.add_table('TABLE_GRADE', grades) do |row, item|
        row['NO'] = count
        row['SUBJECT'] = item.subject.name.to_my_utf8
        row['FIRST_PERIOD'] = item.partial(1).round
        row['SECOND_PERIOD'] = item.partial(2).round
        row['THIRD_PERIOD'] = item.partial(3).round
        row['FOURTH_PERIOD'] = item.partial(4).round
        row['AVERAGE'] = item.average.round
        row['FIRST_RECOVERY'] = item.get_recovery(1).round
        row['SECOND_RECOVERY'] = item.get_recovery(2).round
        total_rating += item.average.round(2)
        count += 1
      end

      if grades.count > 0
        r.add_field 'RATING', (total_rating/grades.count).round(2)
      else
        r.add_field 'RATING', total_rating
      end

      count = 1
      r.add_table('TABLE_PERSONALITY', personalities) do |row, personality|
        row['NO'] = count
        row['PERSONALITY'] = StudentAdditionalGradeField.find(personality.student_additional_grade_field_id).name.to_s.to_my_utf8
        row['FIRST_PERIOD'] = personality.p1
        row['SECOND_PERIOD'] = personality.p2
        row['THIRD_PERIOD'] = personality.p3
        row['FOURTH_PERIOD'] = personality.p4
        row['SUMMARY'] = ''
        count += 1
      end

      if grades.count <= 0
        count = 1
        subjects = student.notas.select { |n| n.subject.batch == student.batch }
        r.add_table('TABLE_GRADE', subjects) do |row, item|
          row['NO'] = count
          row['SUBJECT'] = item.subject.name.to_my_utf8
          row['FIRST_PERIOD'] = pg
          row['SECOND_PERIOD'] = pg
          row['THIRD_PERIOD'] = pg
          row['FOURTH_PERIOD'] = pg
          row['AVERAGE'] = pg
          row['FIRST_RECOVERY'] = pg
          row['SECOND_RECOVERY'] = pg
          count += 1
        end
      end

      if personalities.count <= 0
        count = 1
        grade_fields = StudentAdditionalGradeField.find_all_by_school_id(student.school_id)
        r.add_table('TABLE_PERSONALITY', grade_fields) do |row, personality|
          row['NO'] = count
          row['PERSONALITY'] = personality.name.to_s.to_my_utf8
          row['FIRST_PERIOD'] = pg
          row['SECOND_PERIOD'] = pg
          row['THIRD_PERIOD'] = pg
          row['FOURTH_PERIOD'] = pg
          row['SUMMARY'] = pg
          count += 1
        end
      end
    end

    base_tmp_dir = Rails.root.join('public/tmp')
    file_path = base_tmp_dir.join("#{date} - #{t('gradebook_text')} - #{student.full_name.to_my_utf8}.odt")
    report.generate(file_path)
    `libreoffice --headless --invisible --convert-to #{file_ext} '#{file_path}' --outdir '#{base_tmp_dir}'`
    pdf_file = file_path.to_s.gsub('odt', file_ext)
    send_file(pdf_file)

    #TODO: serpel - create a background runner for delete all files in public/tmp dir
    #FileUtils.remove(file_path)
    #FileUtils.remove(pdf_file)
  end

  def gradebook_option
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def biweekly_option
    @employee = Employee.find_by_user_id(current_user)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  require "odf-report"
  require 'string'
  def biweekly_report

    period = params[:period]
    student = Student.find(params[:id])
    grades = student.biweekly_subject_grades.select { |n| n.subject.batch == student.batch and
                                                          n.period == period}
    personalities = student.biweekly_personality_grades
    pg = 'pg'
    date = Time.now.strftime('%Y-%m-%d')

    odt_template = Rails.root.join('public/templates/decroly_biweekly_report.odt')
    report = ODFReport.new(odt_template) do |r|

      r.add_field 'STUDENT', student.full_name
      r.add_field 'COURSE', student.batch.course_section_name
      r.add_field 'YEAR', Time.now.strftime('%Y')
      r.add_field 'PERIOD', period

      count = 1
      r.add_table('TABLE_GRADE', grades) do |row, item|
        row['NO'] = count
        row['SUBJECT'] = item.subject.name.to_my_utf8
        row['FIRST_WEEK'] = item.w1.round
        row['SECOND_WEEK'] = item.w2.round
        row['THIRD_WEEK'] = item.w3.round
        row['FOURTH_WEEK'] = item.w4.round
        row['TOTAL'] = item.total.round
        count += 1
      end

      count = 1
      r.add_table('TABLE_PERSONALITY', personalities) do |row, personality|
        row['NO'] = count
        row['PERSONALITY'] = StudentAdditionalGradeField.find(personality.student_additional_grade_field_id).name.to_s.to_my_utf8
        row['FIRST_PERIOD'] = personality.w1
        row['SECOND_PERIOD'] = personality.w2
        row['THIRD_PERIOD'] = personality.w3
        row['FOURTH_PERIOD'] = personality.w4
        count += 1
      end

      if grades.count <= 0
        count = 1
        subjects = student.notas.select { |n| n.subject.batch == student.batch }
        r.add_table('TABLE_GRADE', subjects) do |row, item|
          row['NO'] = count
          row['SUBJECT'] = item.subject.name.to_my_utf8
          row['FIRST_WEEK'] = pg
          row['SECOND_WEEK'] = pg
          row['THIRD_WEEK'] = pg
          row['FOURTH_WEEK'] = pg
          row['TOTAL'] = pg
          count += 1
        end
      end

      if personalities.count <= 0
        count = 1
        grade_fields = StudentAdditionalGradeField.find_all_by_school_id(student.school_id)
        r.add_table('TABLE_PERSONALITY', grade_fields) do |row, personality|
          row['NO'] = count
          row['PERSONALITY'] = personality.name.to_s.to_my_utf8
          row['FIRST_PERIOD'] = pg
          row['SECOND_PERIOD'] = pg
          row['THIRD_PERIOD'] = pg
          row['FOURTH_PERIOD'] = pg
          count += 1
        end
      end
    end

    base_tmp_dir = Rails.root.join('public/tmp')
    file_path = base_tmp_dir.join("#{date} - #{t('biweekly_report')}  - #{student.full_name.to_my_utf8}.odt")
    report.generate(file_path)
    `libreoffice --headless --invisible --convert-to pdf '#{file_path}' --outdir '#{base_tmp_dir}'`
    send_file(file_path.to_s.gsub('odt', 'pdf'))
  end
  # GET /school_reports/1
  # GET /school_reports/1.xml
  def show
    @school_report = SchoolReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school_report }
    end
  end

  # GET /school_reports/new
  # GET /school_reports/new.xml
  def new
    @school_report = SchoolReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school_report }
    end
  end

  # GET /school_reports/1/edit
  def edit
    @school_report = SchoolReport.find(params[:id])
  end

  # POST /school_reports
  # POST /school_reports.xml
  def create
    @school_report = SchoolReport.new(params[:school_report])

    respond_to do |format|
      if @school_report.save
        flash[:notice] = 'SchoolReport was successfully created.'
        format.html { redirect_to(@school_report) }
        format.xml  { render :xml => @school_report, :status => :created, :location => @school_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /school_reports/1
  # PUT /school_reports/1.xml
  def update
    @school_report = SchoolReport.find(params[:id])

    respond_to do |format|
      if @school_report.update_attributes(params[:school_report])
        flash[:notice] = 'SchoolReport was successfully updated.'
        format.html { redirect_to(@school_report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /school_reports/1
  # DELETE /school_reports/1.xml
  def destroy
    @school_report = SchoolReport.find(params[:id])
    @school_report.destroy

    respond_to do |format|
      format.html { redirect_to(school_reports_url) }
      format.xml  { head :ok }
    end
  end
  private
  def change_file_extension(file_name, ext)
    file_name.to_s.gsub(ext)
  end
end
