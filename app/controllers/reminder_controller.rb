
class ReminderController < ApplicationController
  before_filter :login_required
  before_filter :protect_view_reminders, :only=>[:view_reminder,:mark_unread,:delete_reminder_by_recipient]
  before_filter :protect_sent_reminders, :only=>[:view_sent_reminder,:delete_reminder_by_sender]

  def index
    @user = current_user
    @reminders = Reminder.paginate(:page => params[:page], :conditions=>["recipient = '#{@user.id}' and is_deleted_by_recipient = false"], :order=>"created_at DESC",:include=>:user)
    @read_reminders = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = true and is_deleted_by_recipient = false", :order=>"created_at DESC")
    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false and is_deleted_by_recipient = false")
  end

  def create_reminder

    url = "#{request.protocol}#{request.host_with_port}"
    @user = current_user
    @courses = []
    @departments = []

    if @user.admin?
       @departments = EmployeeDepartment.find(:all, :conditions=>"status = true")
       @courses = Course.find(:all, :conditions=>"is_deleted = false", :order => "code asc")
    elsif @user.employee?
       # Employee courses and depeartments
       @code = Employee.find_by_employee_number @user['username']
       @departments = EmployeeDepartment.find_all_by_id_and_status(@code['employee_department_id'],"1")
       @courses = Course.find_all_by_school_id_and_is_deleted(current_school,"0", :order => "code asc")
    elsif @user.student?
       @courses = current_course
       @departments = EmployeeDepartment.find(:all, :conditions=>"status = true and code = 'Admin'")
    elsif @user.parent?
      parent = Guardian.find_by_user_id(@user['id'].to_s)
      student = Student.find(parent.ward_id)
      if !student.school_id.nil?
        employees = Employee.find(:all, :conditions => "status = true and school_id = "+student.school_id.to_s)
        @departments = EmployeeDepartment.find_all_by_id(employees)
      else
        @departments = EmployeeDepartment.find(:all, :conditions=>"status = true and code = 'Admin'")
      end
    end

    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false")

    unless params[:send_to].nil?
      recipients_array = params[:send_to].split(",").collect{ |s| s.to_i }
    end
    if request.post?
      unless params[:reminder][:body] == "" or params[:recipients] == ""
        recipients_array = params[:recipients].split(",").collect{ |s| s.to_i }
        @recipients = User.find(recipients_array)

        Delayed::Job.enqueue(DelayedReminderJob.new( :sender_id  => @user.id,
            :recipient_ids => recipients_array,
            :subject=>params[:reminder][:subject],
            :body=>params[:reminder][:body]))

        sender = User.find_by_username('admin').email
        subject = "#{t('new_message')} - " + params[:reminder][:subject]
        to = []
        to << @recipients.map{ |r| r.email }.select { |s| !s.empty? }.uniq
        body = params[:reminder][:body]

        if to.count > 0
          Delayed::Job.enqueue(ImboxMailJob.new(sender,to,subject,body))
        end

        unless params[:copies] == ""

          copy_array = params[:copies].split(",").collect{ |s| s.to_i }
          subject = "Resumen - " + subject
          body = "Mensajes enviados a #{recipients_array.count} personas \n" +
          "Contenido: " + params[:reminder][:body]
          #Delayed::Job.enqueue(ImboxMailJob.new(sender,copies,subject,body)) unless copies.count > 0

          Delayed::Job.enqueue(DelayedReminderJob.new( :sender_id  => @user.id,
                                                       :recipient_ids => copy_array,
                                                       :subject => subject,
                                                       :body=> body)) if copy_array.count > 0
        end

        flash[:notice] = "#{t('flash1')}"
        redirect_to :controller=>"reminder", :action=>"create_reminder"
      else
        flash[:notice]="<b>ERROR:</b>#{t('flash6')}"
        redirect_to :controller=>"reminder", :action=>"create_reminder"
      end
    end
  end

  def select_employee_department
#    @user = current_user
#    @code = Employee.find_by_employee_number @user['username']
#    @departments = EmployeeDepartment.find(@code['employee_department_id'], :conditions => "status = true")

    #@departments = EmployeeDepartment.find(:all, :conditions=>"status = true")
    render :partial=>"select_employee_department"
  end

  def select_users
    @user = current_user   
    users = User.find(:all, :conditions=>"student = false")
    @to_users = users.map { |s| s.id unless s.nil? }
    render :partial=>"to_users", :object => @to_users
  end

  def select_student_course
    @user = current_user
    @batches = Batch.active
    render :partial=> "select_student_course"
  end

  def to_employees
    if params[:dept_id] == ""
      render :update do |page|
        page.replace_html "to_employees", :text => ""
      end
      #return
    else
      department = EmployeeDepartment.find(params[:dept_id])
      employees = department.employees
      @students_user = employees.collect { |s| s.user if s.status == true }
      @students_user.compact!
      render :update do |page|
        page.replace_html 'to_users', :partial => 'to_users', :object => @students_user
      end
    end
  end


  def to_employees2
    if params[:dept_id] == ""
      render :update do |page|
        page.replace_html "to_employees2", :text => ""
      end
      #return
    else
      department = EmployeeDepartment.find(params[:dept_id])
      employees = department.employees
      @students_user = employees.collect { |s| s.user if s.status == true }
      @students_user.compact!
      render :update do |page|
        page.replace_html 'to_users2', :partial => 'to_users2', :object => @students_user
      end
    end
  end

  def to_students
    course = Course.find(params[:course_is]) if !params[:course_is].to_s.empty?

    if course.nil?
      flash[:notice] = "Course not exist or is disable"
      #redirect_to :controller=>"reminder", :action=>"create_reminder"
      return
    else
      students = []
      guardians = []

      batches = course.batches.select {|b| b.is_active == true }
      batches.each do |batch|
         students.concat batch.students
      end

      students.each do |student|
        guardians.concat student.guardians
      end

      @guardians_user = guardians.collect { |guardian| guardian.user }
      @students_user = students.collect { |student| student.user }

      @students_user.compact!
      @guardians_user.compact!

      render :update do |page|
        page.replace_html 'to_users2', :partial => 'to_users', :object => @students_user
        page.replace_html 'to_users3', :partial => 'to_guardian', :object => @guardians_user
      end
    end
  end

  def update_recipient_list
    if params[:recipients]
      recipients_array = params[:recipients].split(",").collect{ |s| s.to_i }
      @recipients = User.find(recipients_array)
      render :update do |page|
        page.replace_html 'recipient-list', :partial => 'recipient_list'
      end
    else
      redirect_to :controller=>:user,:action=>:dashboard
    end
  end

  def update_copy_list
    if params[:copies]
      recipients_array = params[:copies].split(",").collect{ |s| s.to_i }
      @copies = User.find(recipients_array)
      render :update do |page|
        page.replace_html 'copy-list', :partial => 'copy_list'
      end
    else
      redirect_to :controller=>:user,:action=>:dashboard
    end
  end

  def sent_reminder
    @user = current_user
    @sent_reminders = Reminder.paginate(:page => params[:page], :conditions=>["sender = '#{@user.id}' and is_deleted_by_sender = false"],  :order=>"created_at DESC")
    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false")
  end

  def view_sent_reminder
    @sent_reminder = Reminder.find(params[:id2])
  end

  def delete_reminder_by_sender
    @sent_reminder = Reminder.find(params[:id2])
    Reminder.update(@sent_reminder.id, :is_deleted_by_sender => true)
    flash[:notice] = "#{t('flash2')}"
    redirect_to :action =>"sent_reminder"
  end

  def delete_reminder_by_recipient
    user = current_user
    employee = user.employee_record
    @reminder = Reminder.find(params[:id2])
    Reminder.update(@reminder.id, :is_deleted_by_recipient => true)
    flash[:notice] = "#{t('flash2')}"
    redirect_to :action =>"index"
  end

  def view_reminder
    user = current_user
    @new_reminder = Reminder.find(params[:id2])
    Reminder.update(@new_reminder.id, :is_read => true)
    @sender = @new_reminder.user

    if request.post?
      unless params[:reminder][:body] == "" or params[:recipients] == ""
        Reminder.create(:sender=>user.id, :recipient=>@sender.id, :subject=>params[:reminder][:subject],
          :body=>params[:reminder][:body], :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
        flash[:notice]="#{t('flash3')}"
        redirect_to :controller=>"reminder", :action=>"view_reminder", :id2=>params[:id2]
      else
        flash[:notice]="<b>ERROR:</b>#{t('flash4')}"
        redirect_to :controller=>"reminder", :action=>"view_reminder",:id2=>params[:id2]
      end
    end
  end

  def mark_unread
    @reminder = Reminder.find(params[:id2])
    Reminder.update(@reminder.id, :is_read => false)
    flash[:notice] = "#{t('flash5')}"
    redirect_to :controller=>"reminder", :action=>"index"
  end

  def pull_reminder_form
    @employee = Employee.find(params[:id])
    @manager = Employee.find(@employee.reporting_manager_id).user
    render :partial => "send_reminder"
  end

  def send_reminder
    if params[:create_reminder]
      unless params[:create_reminder][:message] == "" or params[:create_reminder][:to] == ""
        Reminder.create(:sender=>params[:create_reminder][:from], :recipient=>params[:create_reminder][:to], :subject=>params[:create_reminder][:subject],
          :body=>params[:create_reminder][:message] , :is_read=>false, :is_deleted_by_sender=>false,:is_deleted_by_recipient=>false)
        render(:update) do |page|
          page.replace_html 'error-msg', :text=> "<p class='flash-msg'>#{t('your_message_sent')}</p>"
        end
      else
        render(:update) do |page|
          page.replace_html 'error-msg', :text=> "<p class='flash-msg'>#{t('enter_subject')}</p>"
        end
      end
    else
      redirect_to :controller=>:reminder
    end
  end

  def reminder_actions
    @user = current_user
    message_ids = params[:message_ids]
    unless message_ids.nil?
      message_ids.each do |msg_id|
        msg = Reminder.find_by_id(msg_id)
        if params[:reminder][:action] == 'delete'
          Reminder.update(msg.id, :is_deleted_by_recipient => true, :is_read => true)
        elsif params[:reminder][:action] == 'read'
          Reminder.update(msg.id, :is_read => true)
        elsif params[:reminder][:action] == 'unread'
          Reminder.update(msg.id, :is_read => false)
        end
      end
    end
    @reminders = Reminder.paginate(:page => params[:page], :conditions=>["recipient = '#{@user.id}' and is_deleted_by_recipient = false"], :order=>"created_at DESC")
    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false and is_deleted_by_recipient = false")

    redirect_to :action=>:index, :page=>params[:page]
  end

  def sent_reminder_delete
    @user = current_user
    message_ids = params[:message_ids]
    unless message_ids.nil?
      message_ids.each do |msg_id|
        msg = Reminder.find_by_id(msg_id)
        Reminder.update(msg.id, :is_deleted_by_sender => true)
      end
    end
    @sent_reminders = Reminder.paginate(:page => params[:page], :conditions=>["sender = '#{@user.id}' and is_deleted_by_sender = false"],  :order=>"created_at DESC")
    @new_reminder_count = Reminder.find_all_by_recipient(@user.id, :conditions=>"is_read = false")

    redirect_to :action=>:sent_reminder, :page=>params[:page]
  end
end
