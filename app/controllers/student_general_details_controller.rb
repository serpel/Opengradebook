class StudentGeneralDetailsController < ApplicationController

  filter_access_to :all
  before_filter :login_required
  
  # GET /student_general_details
  # GET /student_general_details.xml
  def index
    @student_general_details = StudentGeneralDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_general_details }
    end
  end

  def get_students
    parameter = params[:batch_id] == nil ? -1:params[:batch_id]
    @students = Student.find_all_by_batch_id(parameter, :order => 'gender ASC, first_name ASC')
    render(:update) { |page| page.replace_html 'students', :partial => 'students_by_course' }
  end

  def view_details
    begin
      @current_user = current_user
      @employee = Employee.find_by_employee_number(@current_user.username)
      @my_subjects = @employee.subjects.select { |s| s.is_deleted == false }
      b = @my_subjects.map { |a| a.batch_id }.uniq
      @batches = Batch.find_all_by_id(b, :conditions => { :is_deleted => false, :is_active => true })

    rescue Exception => e
      flash[:notice] = "Error: getting students Details, contact Admin! Details: "+ e.to_s
      redirect_to :controller => "user", :action => "dashboard"
    end
  end
  # GET /student_general_details/1
  # GET /student_general_details/1.xml
  #format.html { redirect_to :action => "show_all_student_details",
  #                              :id => params[:id], :batch_id => params[:batch_id] }
  def show
    @student_general_details = StudentGeneralDetail.find(params[:id])  
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @student_general_details }
    end
  end

  def get_periods
    i = 2
    i += 2
  end


  def show_all_student_details
      @student = Student.find(params[:id])
      @details = StudentGeneralDetail.find_all_by_batch_id_and_student_id(@student.batch_id, @student.id)
      if !@details.nil?
        @scores = []
        subjects = @student.batch.subjects.map{ |s| s.id }
        @scores = @student.notas.select { |n| subjects.include? n.subject_id }
        @course = @student.batch.course
        @time = Time.new

        @attendance = []
        @attendance << ["Period", "Days Absent", "Days Tardy", "Demerit"]
        @behavior = []
        @behavior << ["Punctuality", "Effort", "Work Order And Appearance", "Social Skills", "Morals", "Conduct" ]
      
        @details.each do |detail|
          @attendance << [detail.period, detail.daysAbsent, detail.daysTardy, detail.demerit]
          @behavior << [detail.puntuality.upcase, detail.effort.upcase,
                        detail.workOrderAndAppearance.upcase, detail.socialSkills.upcase,
                        detail.morals.upcase, detail.conduct.upcase]
        end
        @attendance = @attendance.transpose
        @behavior = @behavior.transpose
      
        respond_to do |format|
          format.html
          format.xls { render :template => 'show_all_student_details.rhtml.erb' }
        end
      else
        flash[:notice] = 'StudentGeneralDetail not exist'
        redirect_to :back
      end
  end

  # GET /student_general_details/new
  # GET /student_general_details/new.xml
  def new
    @student_general_details = StudentGeneralDetail.new
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @student_general_details }
    end
  end

  # GET /student_general_details/1/edit
  def edit
    @student_general_details = StudentGeneralDetail.find(params[:id])
  end

  # POST /student_general_details
  # POST /student_general_details.xml
  def create
    @student_general_details = StudentGeneralDetail.new(params[:student_general_detail])

    respond_to do |format|
      if @student_general_details.save
        flash[:notice] = 'StudentGeneralDetail was successfully created.'
        format.html { redirect_to @student_general_details }
        format.xml  { render :xml => @student_general_details, :status => :created, :location => @student_general_details }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_general_details.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_general_details/1
  # PUT /student_general_details/1.xml
  def update
    @student_general_details = StudentGeneralDetail.find(params[:id])

    respond_to do |format|
      if @student_general_details.update_attributes(params[:student_general_detail])
        flash[:notice] = 'StudentGeneralDetail was successfully updated.'
        format.html { redirect_to(@student_general_details) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_general_details.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_general_details/1
  # DELETE /student_general_details/1.xml
  def delete
    @student_general_details = StudentGeneralDetail.find(params[:id])
    @student_general_details.destroy

    redirect_to :back
    #redirect_to :action => "show_all_student_details", :student_id=>params[:id], :batch_id=>params[:batch_id]
  end
end
