class BiweeklyPersonalityGradesController < ApplicationController
  # GET /biweekly_personality_grades
  # GET /biweekly_personality_grades.xml
  def index
    @biweekly_personality_grades = BiweeklyPersonalityGrade.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @biweekly_personality_grades }
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

  # GET /biweekly_personality_grades/1
  # GET /biweekly_personality_grades/1.xml
  def show
    @biweekly_personality_grade = BiweeklyPersonalityGrade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @biweekly_personality_grade }
    end
  end

  # GET /biweekly_personality_grades/new
  # GET /biweekly_personality_grades/new.xml
  def new
    @biweekly_personality_grade = BiweeklyPersonalityGrade.new
    @student = Student.find(params[:student_id])
    @student_grade_field = StudentAdditionalGradeField.find(params[:field_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @biweekly_personality_grade }
    end
  end

  # GET /biweekly_personality_grades/1/edit
  def edit
    @biweekly_personality_grade = BiweeklyPersonalityGrade.find(params[:id])
  end

  # POST /biweekly_personality_grades
  # POST /biweekly_personality_grades.xml
  def create
    @biweekly_personality_grade = BiweeklyPersonalityGrade.new(params[:biweekly_personality_grade])

    respond_to do |format|
      if @biweekly_personality_grade.save
        flash[:notice] = 'BiweeklyPersonalityGrade was successfully created.'
        format.html { redirect_to(@biweekly_personality_grade) }
        format.xml  { render :xml => @biweekly_personality_grade, :status => :created, :location => @biweekly_personality_grade }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @biweekly_personality_grade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /biweekly_personality_grades/1
  # PUT /biweekly_personality_grades/1.xml
  def update
    @biweekly_personality_grade = BiweeklyPersonalityGrade.find(params[:id])

    respond_to do |format|
      if @biweekly_personality_grade.update_attributes(params[:biweekly_personality_grade])
        flash[:notice] = 'BiweeklyPersonalityGrade was successfully updated.'
        format.html { redirect_to(@biweekly_personality_grade) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @biweekly_personality_grade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /biweekly_personality_grades/1
  # DELETE /biweekly_personality_grades/1.xml
  def destroy
    @biweekly_personality_grade = BiweeklyPersonalityGrade.find(params[:id])
    @biweekly_personality_grade.destroy

    respond_to do |format|
      format.html { redirect_to(biweekly_personality_grades_url) }
      format.xml  { head :ok }
    end
  end
end
