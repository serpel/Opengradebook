class PlansController < ApplicationController

  filter_access_to :all
  before_filter :login_required
  # GET /plans
  # GET /plans.xml
  def index
    @plans = Plan.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  # GET /plans/1
  # GET /plans/1.xml
  def show
    begin  
      @id = params[:id].nil? ? 0:params[:id]
      @plan = Plan.find(@id)
      @plan = @plan.nil? ? ([]):@plan
   
      @st = Student.find_all_by_batch_id(@plan.subject.batch, :conditions => {:is_deleted => false}, :order => "lower(gender) asc, lower(first_name) asc, lower(last_name) asc")
      @st = @st.nil? ? ([]):@st

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @plan }
      end
      
    rescue Exception => e
      flash[:notice] = "Error: Something Wrong, was happenig with Plan :" + id.to_s + "\nContact with Admin! Details : " + e.to_s
      redirect_to :controller => "user", :action => "dashboard"
    end
  end

  # GET /plans/new
  # GET /plans/new.xml
  def new
    @plan = Plan.new
    if request.post? and @plan.save
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @plan }
      end
    end
  end

  # GET /plans/1/edit
  def edit
    @plan = Plan.find(params[:id])

    if request.post? and @plan.update_attributes(params[:plan])
      flash[:notice] = "#{t('flash3')}"
      redirect_to :back
    end
  end

  # POST /plans
  # POST /plans.xml
  def create
    begin
      @plan = Plan.new(params[:plan])
      if @plan.examen_1 && @plan.examen_2 && @plan.examen_3 && @plan.examen_4 &&
         @plan.acumulado_1 && @plan.acumulado_2 && @plan.acumulado_3 && @plan.acumulado_4
        total_1 = @plan.examen_1 + @plan.acumulado_1
        total_2 = @plan.examen_2 + @plan.acumulado_2
        total_3 = @plan.examen_3 + @plan.acumulado_3
        total_4 = @plan.examen_4 + @plan.acumulado_4
        if total_1 == 100 and total_2 == 100 and total_3 == 100 and total_4 == 100
          respond_to do |format|
            if @plan.save
              #TODO: Set to zero all students notes
              flash[:notice] = 'Ponderacion creada con exito.'
              format.html { redirect_to(@plan) }
              format.xml  { render :xml => @plan, :status => :created, :location => @plan }
            else
              format.html { render :action => "new" }
              format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
            end
          end
        else
          flash[:notice] = 'Ponderacion de parcial excede o es menor que 100 puntos.'
          redirect_to new_subject_ponderation_path(:id=>@plan.subject_id)
        end
      else
        flash[:notice] = 'Ponderacion no puede ser vacia.'
        redirect_to new_subject_ponderation_path(:id=>@plan.subject_id)
      end
    rescue Exception => e
       flash[:notice] = " Error: creating plan, check inputs!"
       redirect_to :controller => "employee", :action => "get_subjects", :status => 303
    end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    begin
    @plan = Plan.find(params[:id])
		h = params[:plan]
		total_1 = h[:examen_1].to_f + h[:acumulado_1].to_f
		total_2 = h[:examen_2].to_f + h[:acumulado_2].to_f
		total_3 = h[:examen_3].to_f + h[:acumulado_3].to_f
		total_4 = h[:examen_4].to_f + h[:acumulado_4].to_f
		if total_1 == 100 and total_2 == 100 and total_3 == 100 and total_4 == 100
		  respond_to do |format|
		    if @plan.update_attributes(params[:plan])
		      flash[:notice] = 'Ponderacion actualizada con exito.'
		      format.html { redirect_to(@plan) }
		      format.xml  { head :ok }
		    else
		      format.html { render :action => "edit" }
		      format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
		    end
		  end
		else
			flash[:notice] = 'Ponderacion de parcial excede o es menor que 100 puntos.'
			render :action => "edit"
		end

    rescue Exception => e
       flash[:notice] = " Error: plan can't be updated!\nDetails: " + e.to_s
       redirect_to :controller => "employee", :action => "get_subjects", :status => 303
    end
  end

  def excel_file_gradebook_for_10grade(plan_id)

    plan ||= Plan.find(plan_id)
    students ||= Student.find_all_by_batch_id(plan.subject.batch,
                                              :conditions => {:is_deleted => false},
                                              :order => "lower(gender) asc, lower(first_name) asc, lower(last_name) asc")

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "#{t('grade')}"

    # format header
    format = Spreadsheet::Format.new :size => 12,
                                     :weight => :bold,
                                     :pattern => 1,
                                     :pattern_fg_color => :silver,
                                     :bottom => :thin,
                                     :top => :thin
    #puts format.inspect
    sheet1.row(0).default_format = format
    sheet1.row(1).default_format = format

    #header sheet1
    sheet1.update_row 0, '','','P1','','','','P2','','','','','','P3','','','','P4'
    row = sheet1.row 1
    row.push "#{t('id')}", "#{t('name')}"

    2.times do |i|
      row.push "E"
      row.push "A"
      row.push "T"
      row.push "N"
      row.push "E"
      row.push "A"
      row.push "T"
      row.push "R1"
      row.push "R2"
      row.push "P"
    end

    #content
    students.each_with_index do |student, i|
      nota = student.notas.find_by_subject_id(plan.subject)
      nota = set_students_notes_equal_zero(plan.subject.id, student.id) if nota.nil?

      sheet1.update_row i+2, student.id, student.full_name.to_s,
                        nota.examen(1), nota.acumulado(1), nota.parcial(1).round, nota.nivelacion(1),
                        nota.examen(2), nota.acumulado(2), nota.parcial(2).round, nota.recuperacion(1), nota.recuperacion(2),
                        nota.promedio_semestre(1).round(1),
                        nota.examen(3), nota.acumulado(3), nota.parcial(3).round, nota.nivelacion(3),
                        nota.examen(4), nota.acumulado(4), nota.parcial(4).round, nota.recuperacion(3), nota.recuperacion(4),
                        nota.promedio_semestre(2).round(1)
    end

    sheet2 = book.create_worksheet :name => "#{t('detail')}"
    row = sheet2.row 0
    row.push "#{t('subject_code')}", "#{t('subject_name')}"
    4.times do |i|
      row.push "#{t('exam'+(i+1).to_s)}"
      row.push "#{t('acum'+(i+1).to_s)}"
      row.push "#{t('recov'+(i+1).to_s)}"
    end
    sheet2.update_row 1, plan.subject.id, plan.subject.name, plan.examen_1, plan.acumulado_1, plan.examen_2, plan.acumulado_2,
                      plan.examen_3, plan.acumulado_3, plan.examen_4, plan.acumulado_4

    return book
  end

  def excel_file_gradebook(plan_id)

    plan ||= Plan.find(plan_id)
    students ||= Student.find_all_by_batch_id(plan.subject.batch,
                                              :conditions => {:is_deleted => false},
                                              :order => "lower(gender) asc, lower(first_name) asc, lower(last_name) asc")

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "#{t('grade')}"

    # format header
    format = Spreadsheet::Format.new :size => 12,
                                     :weight => :bold,
                                     :pattern => 1,
                                     :pattern_fg_color => :silver,
                                     :bottom => :thin,
                                     :top => :thin
    #puts format.inspect
    sheet1.row(0).default_format = format
    sheet1.row(1).default_format = format

    #header sheet1
    sheet1.update_row 0, '','','','','P1','','','P2','','','P3','','','','P4'
    row = sheet1.row 1
    row.push "#{t('id')}", "#{t('name')}"
    4.times do |i|
      row.push "#{t('exam'+(i+1).to_s)}"
      row.push "#{t('acum'+(i+1).to_s)}"
      row.push "#{t('recov'+(i+1).to_s)}"
      row.push "#{t('total')}"
    end
    row.push "#{t('recovery')}"
    row.push "#{t('average')}"

    #content
    students.each_with_index do |student, i|
      nota = student.notas.find_by_subject_id(plan.subject)
      nota = set_students_notes_equal_zero(plan.subject.id, student.id) if nota.nil?

      sheet1.update_row i+2, student.id, student.full_name.to_s.to_my_utf8,
                        nota.examen(1), nota.acumulado(1), nota.recuperacion(1), nota.total_parcial(1).round,
                        nota.examen(2), nota.acumulado(2), nota.recuperacion(2), nota.total_parcial(2).round,
                        nota.examen(3), nota.acumulado(3), nota.recuperacion(3), nota.total_parcial(3).round,
                        nota.examen(4), nota.acumulado(4), nota.recuperacion(4), nota.total_parcial(4).round,
                        nota.get_recovery(1),
                        nota.total_average
    end

    sheet2 = book.create_worksheet :name => "#{t('detail')}"
    row = sheet2.row 0
    row.push "#{t('subject_code')}", "#{t('subject_name')}"
    4.times do |i|
      row.push "#{t('exam'+(i+1).to_s)}"
      row.push "#{t('acum'+(i+1).to_s)}"
      row.push "#{t('recov'+(i+1).to_s)}"
    end
    sheet2.update_row 1, plan.subject.id, plan.subject.name, plan.examen_1, plan.acumulado_1, plan.examen_2, plan.acumulado_2,
                      plan.examen_3, plan.acumulado_3, plan.examen_4, plan.acumulado_4

    return book
  end

  def export
    id = params[:id]

    if params[:id].present?
      plan ||= Plan.find(id)

      ## La calificacion varia dependiendo de la escuela en este caso el grado 10 y 11
      book = (plan.subject.batch.id == 40 or plan.subject.batch.id == 53) ?
          excel_file_gradebook_for_10grade(plan.id) : excel_file_gradebook(plan.id)

      t = DateTime.now
      date = t.strftime("%Y%m%d")
      full_path = create_full_path "#{plan.subject.name}-#{date}.xls"
      book.write full_path

      puts full_path
      data = open(full_path)
      send_data data.read, :filename => data.original_filename, :type=>"application/xls", :x_sendfile=>true
      delete_file full_path

      flash[:notice] = "#{t('export_text')}\n"
      #redirect_to :back
    end
  end

  def import_gradebook(book, subject_id)

      sheet ||= book.worksheet 0

      sheet.each 2 do |row|
        student = Student.find_by_id(row[0])
        nota = Nota.find_by_subject_id_and_student_id(subject_id,row[0]) || Nota.new
        nota.examen_1 = row[2].to_f
        nota.examen_2 = row[6].to_f
        nota.examen_3 = row[10].to_f
        nota.examen_4 = row[14].to_f
        nota.acumulado_1 = row[3].to_f
        nota.acumulado_2 = row[7].to_f
        nota.acumulado_3 = row[11].to_f
        nota.acumulado_4 = row[15].to_f
        nota.recuperacion_1 = row[4].to_f
        nota.recuperacion_2 = row[8].to_f
        nota.recuperacion_3 = row[12].to_f
        nota.recuperacion_4 = row[16].to_f
        nota.recovery = row[18].to_f
        nota.subject_id = subject_id if nota.subject_id.nil?
        nota.student_id = row[0].to_i if nota.student_id.nil?
        nota.save unless student.nil?
      end
      return book
  end

  def import_gradebook_for_10grade(book,  subject_id)
      sheet ||= book.worksheet 0

      sheet.each 2 do |row|
        student = Student.find_by_id(row[0])
        nota = Nota.find_by_subject_id_and_student_id(subject_id,row[0]) || Nota.new
        nota.examen_1 = row[2].to_f
        nota.acumulado_1 = row[3].to_f
        nota.recovery = row[5].to_f

        nota.examen_2 = row[6].to_f
        nota.acumulado_2 = row[7].to_f
        nota.recuperacion_1 = row[9].to_f
        nota.recuperacion_2 = row[10].to_f

        nota.examen_3 = row[12].to_f
        nota.acumulado_3 = row[13].to_f
        nota.recovery2 = row[15].to_f

        nota.examen_4 = row[16].to_f
        nota.acumulado_4 = row[17].to_f
        nota.recuperacion_3 = row[19].to_f
        nota.recuperacion_4 = row[20].to_f

        nota.subject_id = subject_id if nota.subject_id.nil?
        nota.student_id = row[0].to_i if nota.student_id.nil?
        nota.save unless student.nil?
      end

      return book
  end

  require 'spreadsheet'
  def import

    @errors ||= []
    if request.post? && params[:file].present?
      uploaded_io = params[:file]
      file_path = copy_file_to_public uploaded_io

      book = Spreadsheet.open file_path
      sheet ||= book.worksheet 1

      #puts sheet.inspect
      subject_id = sheet.rows[1][0] if sheet.rows.size > 0

      subject = Subject.find subject_id
      result = (subject.batch_id == 40 or subject.batch_id == 53) ?
          import_gradebook_for_10grade(book, subject_id) : import_gradebook(book, subject_id)

      delete_file file_path
      flash[:notice] = "#{t('completed_text')}\n"
      redirect_to :back
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to(plans_url) }
      format.xml  { head :ok }
    end
  end

  private

  def set_students_notes_equal_zero(subject_id, student_id)
    if subject_id.present? and student_id.present?
       nota = Nota.new
       nota.set_notes_to_zero subject_id, student_id
       nota.save
       nota
    end
  end

  def copy_file_to_public(filename)
    File.open(Rails.root.join('public', 'uploads', "#{filename.original_filename}"), 'w') do |file|
      file.write(filename.read)
      file.path
    end
  end

  def create_full_path(name)
    Rails.root.join('public', 'uploads', "#{name}")
  end

  def delete_file(fullpath)
    File.delete fullpath
    puts "removed file: #{fullpath}"
  end

  def get_data_at(csv_array, header_row, begin_number, end_number)  # makes arrays of hashes out of CSV's arrays of arrays
    result = []
    return result if csv_array.nil? || csv_array.empty? || begin_number < 0 ||
        end_number < begin_number

    headerA = csv_array.fetch(header_row)
    headerA.map!{|x| x.downcase.to_sym }
    count = 0
    csv_array.each do |row|
      result << Hash[ headerA.zip(row) ] if count >= begin_number and count <= end_number
      count+=1
    end
    return result
  end

  def get_data(csv_array)  # makes arrays of hashes out of CSV's arrays of arrays
    result = []
    return result if csv_array.nil? || csv_array.empty?
    headerA = csv_array.shift             # remove first array with headers from array returned by CSV
    headerA.map!{|x| x.downcase.to_sym }  # make symbols out of the CSV headers
    csv_array.each do |row|               #    convert each data row into a hash, given the CSV headers
      result << Hash[ headerA.zip(row) ]  #    you could use HashWithIndifferentAccess here instead of Hash
    end
    return result
  end
end
