class BiweeklySubjectGradesController < ApplicationController


  def batches
    @employee = Employee.find(params[:id])
    @batches = Batch.all :joins => {:subjects =>
                                    [{:employees_subjects => :employee}]},
                         :conditions => {'employees.id' => @employee.id}
  end

  def subjects
    @batch = Batch.find(params[:id])
    employee = Employee.find(params[:employee])
    @subjects =  employee.subjects.select { |s| s.batch == @batch }
    render(:update) do |page|
      page.replace_html 'subjects', :partial => 'subjects'
    end
  end

  def student_grades
    @subject = Subject.find(params[:id])
    batch = @subject.batch
    @students = batch.students.select {|s| !s.is_deleted }

    respond_to do |format|
      format.html # student_grades.html.erb
      format.xml  { render :xml => @students }
    end
  end

  # GET /biweekly_subject_grades
  # GET /biweekly_subject_grades.xml
  def index
    @biweekly_subject_grades = BiweeklySubjectGrade.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @biweekly_subject_grades }
    end
  end

  # GET /biweekly_subject_grades/1
  # GET /biweekly_subject_grades/1.xml
  def show
    @biweekly_subject_grade = BiweeklySubjectGrade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @biweekly_subject_grade }
    end
  end

  # GET /biweekly_subject_grades/new
  # GET /biweekly_subject_grades/new.xml
  def new
      @student = Student.find(params[:student])
      @subject = Subject.find(params[:subject])
      @period = params[:period]
      @biweekly_subject_grade = BiweeklySubjectGrade.new
      @biweekly_subject_grade.subject_id = params[:subject]
      @biweekly_subject_grade.student_id = params[:student]
      @biweekly_subject_grade.period = params[:period]

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @biweekly_subject_grade }
      end
  end

  # GET /biweekly_subject_grades/1/edit
  def edit
    @biweekly_subject_grade = BiweeklySubjectGrade.find(params[:id])
  end

  # POST /biweekly_subject_grades
  # POST /biweekly_subject_grades.xml
  def create
    @biweekly_subject_grade = BiweeklySubjectGrade.new(params[:biweekly_subject_grade])

    tmp = BiweeklySubjectGrade.find_by_student_id_and_subject_id_and_period(@biweekly_subject_grade.student_id,
                                                                            @biweekly_subject_grade.subject_id,
                                                                            @biweekly_subject_grade.period)
    if tmp
      respond_to do |format|
        format.html { redirect_to :action => 'student_grades', :id => tmp.subject.id }
        format.xml { render :xml => tmp }
      end
    else
      respond_to do |format|
        if @biweekly_subject_grade.save
          flash[:notice] = 'BiweeklySubjectGrade was successfully created.'
          format.html { redirect_to :action => 'student_grades', :id => @biweekly_subject_grade.subject.id }
          format.xml  { render :xml => @biweekly_subject_grade, :status => :created, :location => @biweekly_subject_grade }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @biweekly_subject_grade.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /biweekly_subject_grades/1
  # PUT /biweekly_subject_grades/1.xml
  def update
    @biweekly_subject_grade = BiweeklySubjectGrade.find(params[:id])

    respond_to do |format|
      if @biweekly_subject_grade.update_attributes(params[:biweekly_subject_grade])
        flash[:notice] = 'BiweeklySubjectGrade was successfully updated.'
        format.html { redirect_to(@biweekly_subject_grade) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @biweekly_subject_grade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /biweekly_subject_grades/1
  # DELETE /biweekly_subject_grades/1.xml
  def destroy
    @biweekly_subject_grade = BiweeklySubjectGrade.find(params[:id])
    @biweekly_subject_grade.destroy

    respond_to do |format|
      format.html { redirect_to(biweekly_subject_grades_url) }
      format.xml  { head :ok }
    end
  end
end
