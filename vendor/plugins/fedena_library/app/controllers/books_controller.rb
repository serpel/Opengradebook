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
class BooksController < ApplicationController
  before_filter :login_required
  before_filter :check_book_status, :only =>[ :edit , :update ]
  filter_access_to :all

  def index
    @books = Book.paginate :page => params[:page]
    @tags = Tag.find(:all)
  end

  def new
    @tagg = []
    @book = Book.find(:last)
    @book_number = @book.book_number.next unless @book.nil?
    unless params[:author].nil?
      @book_title = params[:title]
      @author = params[:author]
      @detail = Book.find_by_author_and_title(@author, @book_title)
      @tagg = @detail.tag_list
    else
      @book_title = ''
      @author = ''
    end
    
    @book = Book.new
    @tags = Tag.find(:all)
  end

  def create
    @tagg = []
    @book = Book.find(:last)
    @book_number = @book.book_number.next unless @book.nil?
    @book_number = params[:book][:book_number] unless params[:book][:book_number].nil?

    unless params[:author].nil?
      @book_title = params[:title]
      @author = params[:author]
      @detail = Book.find_by_author_and_title(@author, @book_title)
      @tagg = @detail.tag_list
    else
      @book_title = ''
      @author = ''
    end

    @book = Book.new
    @tags = Tag.find(:all)
    @book = Book.new(params[:book])

    @count = params[:tag][:count].to_i
    @custom_tags = params[:tag][:list]
    tags = @custom_tags.split(',')
    unless params[:tag][:count] == ""
      saved = 0
      temp_book_number = params[:book][:book_number]
      tags << params[:book][:tag_list]
      @count.times do |c|
        book_number = temp_book_number
        if @book = Book.create(:title=> params[:book][:title], :author=> params[:book][:author], :tag_list =>tags, :book_number =>book_number, :status=>'Available')
          unless @book.id.nil?
            saved += 1
            Book.update(@book.id, :tag_list => tags)
            temp_book_number = temp_book_number.next
          end
        end
      end
      if  saved == @count
        flash[:notice]="#{t('flash1')}"
        redirect_to books_path
      else
        render 'new'
      end
    else
      @book.errors.add_to_base("#{t('flash5')}")
      render 'new'
    end
   
  end

  def edit
    @book = Book.find(params[:id])
    @tags = Tag.find(:all)
  end

  def update
    @book = Book.find(params[:id])
    @tags = Tag.all
    @custom_tags = params[:tag][:list]
    tags = @custom_tags.split(',')
    params[:book][:tag_list]=[] if params[:book][:tag_list].blank?
    params[:book][:tag_list] << tags unless tags.blank?
      
    if @book.update_attributes(params[:book])
      redirect_to @book
      flash[:notice]="#{t('flash2')}"
    else
      render 'edit'
    end
  end

  def show
    @book = Book.find(params[:id])
    @lender = Student.find_by_admission_no @book.book_movement.user.username unless @book.book_movement_id.nil?
    @lender ||= Employee.find_by_employee_number @book.book_movement.user.username unless @book.book_movement_id.nil?
    @reservations = BookReservation.find_all_by_book_id(@book.id)
    @book_reserved = BookReservation.find_by_book_id(@book.id)
  end

  def destroy
    @book = Book.find(params[:id])
    if @book.book_movement_id.nil? #or @book.status=='Lost'
      @book.destroy
      flash[:notice] ="#{t('flash3')}"
    else
      flash[:warn_notice] ="#{t('flash4')}"
    end
    redirect_to books_path
  end

  def sort_by
    sort = params[:sort][:on]
    @books = Book.find(:all, :conditions=>["status='#{sort}'"])
    render(:update) do |page|
      page.replace_html 'books', :partial=>'books'
    end
  end
  private

  def check_book_status
    @book = Book.find(params[:id])
    redirect_to :action => :show , :id => @book.id  if @book.status == 'Borrowed'
  end

end
