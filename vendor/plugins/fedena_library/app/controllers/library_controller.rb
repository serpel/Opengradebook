#Copyright 2010 Foradian Technologies Private Limited
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing,
#software distributed under the License is distributed on an
#"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#KIND, either express or implied.  See the License for the
#specific language governing permissions and limitations
#under the License.
class LibraryController < ApplicationController
  before_filter :login_required
  filter_access_to :all


  def index
    
  end

  def search_book
   
  end

  def search_result
    @query = params[:search][:name]
    @type = params[:search][:search_by]
    if params[:search][:search_by] == 'tag'
      @books = Book.find_tagged_with(params[:search][:name])
    elsif params[:search][:search_by] == 'title'
      @books = Book.title_like_any(params[:search][:name])
    elsif params[:search][:search_by] == 'author'
      @books = Book.author_like_any(params[:search][:name])
    else
      @books = Book.book_number_like_any(params[:search][:name])
    end
    if @books.empty? or params[:search][:name].empty?
      flash[:warn_notice] = "#{t('flash1')}"
      redirect_to :action=>'search_book'
    end
  end

  def detail_search
    if request.post?
      unless params[:search][:title].empty? or params[:search][:author].empty?
        @book_title = params[:search][:title]
        @book_author = params[:search][:author]
        flash[:notice] = nil
        @books = Book.find_all_by_title_and_author(params[:search][:title],params[:search][:author])
        @available_books = Book.find_all_by_title_and_author(params[:search][:title],params[:search][:author], :conditions=>["status = 'Available'"])
        @borrowed_books = Book.find_all_by_title_and_author(params[:search][:title],params[:search][:author], :conditions=>["status = 'Borrowed'"])
        @book_list =  Book.find_by_title_and_author(params[:search][:title],params[:search][:author])
        @tags = @book_list.tag_list unless @book_list.nil?
      else
        flash[:warn_notice] = "#{t('flash2')}"
      end
    end
  end

  def availabilty
    render :partial=>'availability'
  end

  def card_setting
   
  end

  def show_setting
    @course = Course.find(params[:course_name])
    @card_setting = LibraryCardSetting.find_all_by_course_id(@course.id)
    render(:update) do |page|
      page.replace_html 'card_setting', :partial=>'library_card_setting'
    end
  end

  def add_new_setting
    @setting = LibraryCardSetting.new
    @course = Course.find params[:id] if request.xhr? and params[:id]
    @student_categories = StudentCategory.active
    respond_to do |format|
      format.js { render :action => 'new' }
    end
  end

  def create_setting
    @library_setting = LibraryCardSetting.new(params[:library_card_setting])
    respond_to do |format|
      if  @library_setting.save
        @course = Course.find(@library_setting.course_id)
        @card_setting = LibraryCardSetting.find_all_by_course_id(@course.id)
        format.js { render :action => 'create' }
      
      else
        @error = true
        format.html { render :action => "new" }
        format.js { render :action => 'create' }
      end
    end
  end

  def edit_card_setting
    @setting = LibraryCardSetting.find(params[:id])
    @course = Course.find @setting.course_id
    respond_to do |format|
      format.js { render :action => 'edit' }
    end
  end

  def update_card_setting
    @setting = LibraryCardSetting.find(params[:id])
    respond_to do |format|
      if @setting.update_attributes(params[:library_card_setting])
        @course = Course.find(@setting.course_id)
        @card_setting = LibraryCardSetting.find_all_by_course_id(@course.id)
        format.js { render :action => 'update' }
      else
        @error = true
        format.html { render :action => "edit" }
        format.js { render :action => 'update' }
      end
    end
  end

  def delete_card_setting
    @setting = LibraryCardSetting.find(params[:id])
    @course = Course.find(@setting.course_id)
    @setting.delete
    @card_setting = LibraryCardSetting.find_all_by_course_id(@course.id)
    respond_to do |format|
      format.js { render :action => 'destroy' }
    end
  end

  def movement_log
    @log = BookMovement.paginate( :conditions=>["status !='Returned'"], :order=>"due_date ASC", :page=>params[:page])
  end

  def book_statistics
    if params[:type] == 'title'
      @books = Book.find_all_by_title(params[:name])
    else

      @books = Book.find_all_by_author(params[:name])
    end
  end

  def book_reservation
    @book_reservation_time_out = Configuration.find_by_config_key('BookReservationTimeOut')
    if request.post?
    end
  end

  def library_report
    @start_date = params[:start]
    @end_date  = params[:end]
    @batch = Batch.all
    library_id = FinanceTransactionCategory.find_by_name('Library').id
    @transactions = FinanceTransaction.find(:all, :conditions=>"category_id = '#{library_id}' and transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'")

  end

  def library_report_pdf
    @start_date = params[:start]
    @end_date  = params[:end]
    @batch = Batch.all
    library_id = FinanceTransactionCategory.find_by_name('Library').id
    @transactions = FinanceTransaction.find(:all, :conditions=>"category_id = '#{library_id}' and transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'")
   render :pdf=>'library_report_pdf'
  end

  def batch_library_report
    @start_date = params[:start]
    @end_date  = params[:end]
    library_id = FinanceTransactionCategory.find_by_name('Library').id
    @batch = Batch.find(params[:id])
    @transactions = FinanceTransaction.find(:all, :conditions=>"category_id = '#{library_id}' and transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'")

  end

  def batch_library_report_pdf
    @start_date = params[:start]
    @end_date  = params[:end]
    library_id = FinanceTransactionCategory.find_by_name('Library').id
    @batch = Batch.find(params[:id])
    @transactions = FinanceTransaction.find(:all, :conditions=>"category_id = '#{library_id}' and transaction_date >= '#{@start_date}' and transaction_date <= '#{@end_date}'")
    render :pdf=>'batch_library_report_pdf'
  end

  def student_library_details
    @current_user = current_user
    @available_modules = Configuration.available_modules
    @config = Configuration.find_by_config_key('NetworkState').config_value
    @student = Student.find(params[:id])
    @reserved = @student.book_reservations
    @borrowed = @student.book_movements
  end

  def employee_library_details
    @current_user = current_user
    @available_modules = Configuration.available_modules
    @config = Configuration.find_by_config_key('NetworkState').config_value
    @employee = Employee.find(params[:id])
    @reserved = @employee.book_reservations
    @borrowed = @employee.book_movements
    @new_reminder_count = Reminder.find_all_by_recipient(@current_user.id, :conditions=>"is_read = false")
  end
end
