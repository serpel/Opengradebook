class StudentGradePersonalitiesController < ApplicationController
  # GET /student_grade_personalities
  # GET /student_grade_personalities.xml
  def index
    @personalities = StudentAdditionalGradeField.find_all_by_school_id current_school

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personalities }
    end
  end


  def by_student
    @student = Student.find(params[:id])
    @personalities = StudentAdditionalGradeField.find_all_by_school_id(current_school)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personalities }
    end
  end

  def get_subjects
    begin
      @current_user = current_user
      @employee = Employee.find_by_employee_number(@current_user.username)
      @my_subjects = @employee.subjects.select { |s| s.is_deleted == false }

      b = @my_subjects.map { |a| a.batch_id }.uniq
      @batches = Batch.find_all_by_id(b, :conditions => { :is_deleted => false, :is_active => true })
      if b.count > 0
        @my_subjects = @my_subjects.select { |s| s.batch_id == b.first.to_i }
      end

    rescue Exception => e
      flash[:notice] = "Error: getting batches, contact Admin! Details: "+ e.to_s
      redirect_to :controller => "user", :action => "dashboard"
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

  # GET /student_grade_personalities/1
  # GET /student_grade_personalities/1.xml
  def show
    @student_grade_personality = StudentGradePersonality.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_grade_personality }
    end
  end

  # GET /student_grade_personalities/new
  # GET /student_grade_personalities/new.xml
  def new
    @student_grade_personality = StudentGradePersonality.new
    @student = Student.find(params[:student_id])
    @student_grade_field = StudentAdditionalGradeField.find(params[:field_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_grade_personality }
    end
  end

  # GET /student_grade_personalities/1/edit
  def edit
    @student = Student.find(params[:student])
    @student_grade_personality = StudentGradePersonality.find(params[:id])
  end

  # POST /student_grade_personalities
  # POST /student_grade_personalities.xml
  def create
    @student_grade_personality = StudentGradePersonality.new(params[:student_grade_personality])

    respond_to do |format|
      if @student_grade_personality.save
        flash[:notice] = 'StudentGradePersonality was successfully created.'
        format.html { redirect_to :action => "by_student", :id => @student_grade_personality.student.id }
        format.xml  { render :xml => @student_grade_personality, :status => :created, :location => @student_grade_personality }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_grade_personality.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_grade_personalities/1
  # PUT /student_grade_personalities/1.xml
  def update
    @student_grade_personality = StudentGradePersonality.find(params[:id])

    respond_to do |format|
      if @student_grade_personality.update_attributes(params[:student_grade_personality])
        flash[:notice] = 'StudentGradePersonality was successfully updated.'
        format.html { redirect_to :action => 'by_student', :id => @student_grade_personality.student.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_grade_personality.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_grade_personalities/1
  # DELETE /student_grade_personalities/1.xml
  def destroy
    @student_grade_personality = StudentGradePersonality.find(params[:id])
    @student_grade_personality.destroy

    respond_to do |format|
      format.html { redirect_to(student_grade_personalities_url) }
      format.xml  { head :ok }
    end
  end
end
