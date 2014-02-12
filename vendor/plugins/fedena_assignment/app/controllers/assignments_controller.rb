class AssignmentsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  
  def index
    @current_user = current_user
    if @current_user.employee?
      begin
        @subjects = current_user.employee_record.subjects
        @subjects = @subjects.sort_by { |obj| obj.batch_id }
        @subjects.reject! {|s| s.batch.nil? ? true:(!s.batch.is_active)}
      rescue Exception => e
        flash[:notice] = "#{"Some Batchs are invalids, contact with Admin!"} Details: " + e.to_s
        redirect_to :controller => "user", :action => "dashboard"
      end
    elsif @current_user.student?
      @assignments = Assignment.for_student current_user.student_record.id
    elsif @current_user.parent?      
      st = Student.find_by_admission_no current_user.parent_record.admission_no 
      @assignments = Assignment.for_student st.id
    end
  end


  def subject_assignments

    @subject =Subject.find_by_id params[:subject_id]
    unless @subject.nil?
      employee_id = current_user.employee_record.id
      @assignments =Assignment.paginate  :conditions=>"subject_id=#{@subject.id} and employee_id=#{employee_id}",:order=>"duedate desc", :page=>params[:page]
    end
    render(:update) do |page|
      page.replace_html 'subject_assignments_list', :partial=>'subject_assignments'
    end
  end


  def new
    if current_user.employee?
      @subjects = current_user.employee_record.subjects
      @subjects = @subjects.sort_by { |obj| obj.batch_id }
      @subjects.reject! {|s| s.batch.nil? ? true:(!s.batch.is_active)}
      @assignment= Assignment.new
      unless params[:subject_id].nil?
        subject = Subject.find_by_id(params[:subject_id])
        employeeassociated = EmployeesSubject.find_by_subject_id_and_employee_id( subject.id,current_user.employee_record.id)
        unless employeeassociated.nil?
          if subject.elective_group_id.nil?
            @students = subject.batch.students
          else
            assigned_students = StudentsSubject.find_all_by_subject_id(subject.id)
            @students = assigned_students.map{|s| Student.find s}
          end
          @assignment = subject.assignments.build
        end
      end
    end
  end


  def subjects_students_list
    @subject = Subject.find_by_id params[:subject_id]
    unless @subject.nil?
      if @subject.elective_group_id.nil?
        @students = @subject.batch.students
      else
        assigned_students = StudentsSubject.find_all_by_subject_id(@subject.id)
        @students = assigned_students.map{|s| s.student}
      end
    end
    render(:update) do |page|
      page.replace_html 'subjects_student_list', :partial=>"subjects_student_list"
    end
  end


  def assignment_student_list
    #List the students of the assignment based on their Status of their assignment
    @assignment = Assignment.find_by_id params[:id]
    @status = params[:status]
    if @status == "assigned"
      assigned_students= @assignment.student_list.split(",")
      @students = assigned_students.map{|s| Student.find_by_id s}
      @students = @students.sort_by{|s| s.full_name}
    elsif @status == "answered"
      @answers = @assignment.assignment_answers
      @answers  = @answers.sort_by{|a| a.updated_at}
      @students = @answers.map{|a| a.student }
    elsif @status== "pending"
      answers = @assignment.assignment_answers
      answered_students = answers.map{|a| a.student_id.to_s }
      assigned_students= @assignment.student_list.split(",")
      pending_students = assigned_students - answered_students
      @students = pending_students.map{|s| Student.find_by_id s}
      @students = @students.sort_by{|s| s.full_name}
    end
    render(:update) do |page|
      page.replace_html 'student_list', :partial=>'student_list'
    end

  end

  def create
    url = "#{request.protocol}#{request.host_with_port}"
    student_ids = params[:assignment][:student_ids]
    params[:assignment].delete(:student_ids)
    @subject = Subject.find_by_id(params[:assignment][:subject_id])
    @assignment = Assignment.new(params[:assignment])
    @assignment.student_list = student_ids.join(",") unless student_ids.nil?
    @assignment.employee = current_user.employee_record
    unless @subject.nil?
      if @assignment.save
        subject = "#{t('new_homework')} - "+@subject.name+": "+@assignment.title
        students = Student.find_all_by_id(student_ids, :conditions => { :is_deleted => false})
        to = []
        students.each do |s|
          to << s.guardians.map { |m| m.email }.select { |g| !g.empty? }.uniq unless s == nil
        end
        to << students.map { |m| m.email }.select { |s| !s.empty? }.uniq unless students == nil
        
        if to.count > 0
          Delayed::Job.enqueue(HomeWorkMailJob.new(current_user,to,subject,@assignment.content))
        end
        flash[:notice] = "#{t('new_assignment_sucessfuly_created')}"
        redirect_to :action=>:index
      else
        if current_user.employee?
          @subjects = current_user.employee_record.subjects
        
          @subjects.reject! {|s| !s.batch.is_active?}
          @students = @subject.batch.students
        end
        render :action=>:new
      end
    else
      unless @assignment.save
        @subjects = current_user.employee_record.subjects
        render :action=>:new
      end
    end
  end

  def show
    @assignment  = Assignment.find(params[:id])
    @current_user = current_user
    @assignment_answers = @assignment.assignment_answers
    @students_assigned_count = @assignment.student_list.split(",").count
    @answered_count = @assignment_answers.count
    @pending_count =     @students_assigned_count  -  @answered_count
    @assignment_answers = AssignmentAnswer.find_all_by_student_id_and_assignment_id(current_user.student_record.id,@assignment.id) if current_user.student?
  end

  def edit
    @assignment  = Assignment.find(params[:id])
    @subject = @assignment.subject
    unless @subject.nil?
      if @subject.elective_group_id.nil?
        @students = @subject.batch.students
      else
        assigned_students = StudentsSubject.find_by_subject_id(@subject.id)
        @students = assigned_students.map{|s| Student.find s}
      end
    end
    @assigned_students = @assignment.student_list.split(",").map {|s| Student.find s }

    if current_user.employee?
      @subjects = current_user.employee_record.subjects
      
      @subjects.reject! {|s| s.batch.nil? ? true:(!s.batch.is_active)}
    end
  end
  def update
    @assignment = Assignment.find_by_id(params[:id])
    student_ids = params[:assignment][:student_ids]
    params[:assignment].delete(:student_ids)
    @assignment.student_list = student_ids.join(",") unless student_ids.nil?
    if  @assignment.update_attributes(params[:assignment])
      flash[:notice]="#{t('assignment_details_updated')}"
      redirect_to @assignment
    else
      redirect_to edit_assignment_path(@assignment)
    end
  end

  def destroy
    @assignment = Assignment.find_by_id(params[:id])
    if (current_user.admin?) or (@assignment.employee_id == current_user.employee_record.id)
      @assignment.destroy
      flash[:notice] = "#{t('assignment_sucessfully_deleted')}"
      redirect_to assignments_path
    else
      flash[:notice] = "#{t('you_do_not_have_permission_to_delete_this_assignment')}"
      redirect_to edit_assignment_path(@assignment)
    end

  end
  def download_attachment
    #download the  attached file
    @assignment =Assignment.find params[:id]
    if @assignment.download_allowed_for(current_user)
      send_file  @assignment.attachment.path , :type=>@assignment.attachment.content_type
    else
      flash[:notice] = "#{t('you_are_not_allowed_to_download_that_file')}"
      redirect_to :controller=>:assignments
    end
  end

end
