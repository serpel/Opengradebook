class AssignmentAnswersController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def new
    @assignment= Assignment.find_by_id(params[:assignment_id])
    @assignment_answer = @assignment.assignment_answers.build
  end

  def create
    @assignment= Assignment.find_by_id(params[:assignment_id])
    @assignment_answer = @assignment.assignment_answers.build(params[:assignment_answer])
    @assignment_answer.student_id = current_user.student_record.id
    if @assignment_answer.save
      flash[:notice] == "#{t('assignment_submitted')}"
      redirect_to assignments_path
    else
      render :action=>:new
    end
  end

  def show
    @assignment= Assignment.find params[:assignment_id]
    @assignment_answer= AssignmentAnswer.find_by_id(params[:id])
    unless @assignment.download_allowed_for(current_user)
      flash[:notice] = "#{t('you_are_not_allowed_to_view_that_page ')}"
      redirect_to assignments_path
    end
  end

  def edit

    @assignment= Assignment.find params[:assignment_id]
    @assignment_answer= AssignmentAnswer.find params[:id]
    if @assignment_answer.download_allowed_for(current_user)
      if @assignment_answer.status == "ACCEPTED"
        flash[:notice]="#{t('you_cannot_edit_the_assignment_once_it_is_accepted')}"
        redirect_to assignment_assignment_answer_path(@assignment,@assignment_answer)
      end
    else
      flash[:notice] ="#{t('you_cannot_edit_this_assignment')}"
      redirect_to assignments_path
    end
  end
  def update
    @assignment = Assignment.find params[:assignment_id]
    @assignment_answer= AssignmentAnswer.find params[:id]
    @assignment_answer.status = "0"
    if @assignment_answer.update_attributes(params[:assignment_answer])
      flash[:notice] = "#{t('assignment_successfuly_updated')}"
      redirect_to assignment_assignment_answer_path @assignment,@assignment_answer
    else
      flash[:notice] = "#{t('failed_to_update_assignment')}"
      render :action=>:edit
    end
  end

  def evaluate_assignment
    #Change the status of assignment Answer submitted
    @assignment_answer=AssignmentAnswer.find params[:id]
    if current_user.employee?
      if  current_user.employee_record.id == @assignment_answer.assignment.employee_id
        @assignment_answer.status = params[:status]
        if @assignment_answer.save
          flash[:notice] = "#{t('assignment_text')}" + " #{@assignment_answer.status.capitalize}"
        else
          flash[:notice] = "#{t('failed_to_set_status_of_assignment')}"
        end
      end
    else
      flash[:notice] = "#{t('you_cannot_approve_or_reject_this_assignment')}"
    end
    redirect_to assignment_assignment_answer_path(@assignment_answer.assignment,@assignment_answer)
  end
  def download_attachment
    #Method for downloading the attachment
    @assignment_answer =AssignmentAnswer.find params[:assignment_answer]
    if @assignment_answer.download_allowed_for(current_user)
      send_file  @assignment_answer.attachment.path, :type=>@assignment_answer.attachment.content_type
    else
      flash[:notice] = "#{t('you_are_not_allowed_to_download_that_file')}"
      redirect_to :controller=>:assignments
    end
  end
end
