class ImportController < ApplicationController

  filter_access_to :all
  before_filter :login_required

  require 'csv'

  def index
     @batches = Batch.active
  end

  def import_csv

    if request.post? && params[:file].present?
      filename = params[:file].read
      n, errs = 0, []
      #@last_admitted_student = Student.find(:last)
      flash[:notice] = "Successfull"

        CSV.parse(filename) do |row|
          n += 1
          next if n == 1 or row.join.blank?

          row = row.to_s.split(/[ ,;\s]/)
          @date = DateTime.now.strftime('%m/%d/%Y')

          st = Student.new
          st.admission_no = row[0]
          st.first_name = row[1]
          st.last_name = row[2]
          st.date_of_birth = row[3]
          st.email = row[4]
          st.gender = row[5]
            
          @batch = Batch.find(params[:course][:course_id])
          @course = Course.find(@batch.course_id)

          st.batch_id = @batch.id
          st.school_id = @course.school_id
            
          #by Default take this parameter from local configuration
          st.is_sms_enabled = 1
          st.country_id = 73
          st.nationality_id = 73
          st.admission_date = @date
          st.is_active = 1

          begin
            if st.create_user_and_validate == true
              st.save
            end
          rescue Exception => e
            flash[:notice] = e.to_s
          end

          gu = Guardian.new
          gu.first_name = row[6]
          gu.last_name = row[7]
          gu.relation = row[8]
          gu.email = row[9]

          gu.country_id = 73
          _st = Student.find_by_admission_no st.admission_no
          gu.ward_id = _st.id 

          begin
            #gu.create_guardian_user(_st)
            #gu.save!
          rescue Exception => e
            flash[:notice] = e.to_s
          end
      end
      
    else
      flash[:notice] = "Error file not choosen, select the batch and the correct file"
    end

    redirect_to :action => 'index'
  end

  private
  def list_batches
    unless params[:course_id] == ''
      @batches = Batch.find(:all, :conditions=>"course_id = #{params[:course_id]}",:order=>"id DESC")
    else
      @batches = []
    end
    render(:update) do |page|
      page.replace_html 'course_batches', :partial=> 'list_batches'
    end
  end
end
