class ImportController < ApplicationController
  before_filter :login_required

  def index
     @batches = Batch.active
  end

=begin
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
=end

  require 'csv'
  def import_csv

    batch_id = params[:batch][:id]
    @batch = Batch.find batch_id
    @course = @batch.course

    if request.post? &&
       params[:file].present? && !batch_id.nil?

      file = params[:file].read
      csv_data = get_data( CSV.parse( file ) )

      csv_data.each do |data|

        default_date = '01/01/1999'
        student = Student.new
        student.admission_no = data[:student_username].to_s
        student.first_name = data[:student_first_name].to_s
        student.last_name = data[:student_last_name].to_s
        student.date_of_birth = data[:student_date_of_birth].to_s.empty? ? default_date : data[:student_date_of_birth].to_s
        student.email = data[:student_email].to_s.empty? ? "" : data[:student_email].to_s
        student.gender = data[:student_gender].to_s
        student.admission_date = DateTime.now.strftime('%m/%d/%Y')
        student.batch_id = @batch.id
        student.school_id = @course.school_id
        student.country_id = student.nationality_id = Configuration.default_country
        student.is_sms_enabled = 1
        student.is_active = true
        student.create_user_and_validate

        if student.save!
          guardian = Guardian.new
          guardian.first_name = data[:parent_first_name].to_s
          guardian.last_name = data[:parent_first_name].to_s
          guardian.email = data[:parent_email].to_s
          guardian.relation = data[:parent_relation].to_s
          guardian.country_id = Configuration.default_country
          guardian.create_guardian_user student
          guardian.save!
        end
      end
      flash[:notice] = "Import succesfull"
      redirect_to :back
    else
      flash[:notice] = "Error"
      redirect_to :back
    end
  end

  def get_data(csv_array)  # makes arrays of hashes out of CSV's arrays of arrays
    result = []
    return result if csv_array.nil? || csv_array.empty?
    headerA = csv_array.shift             # remove first array with headers from array returned by CSV
    headerA.map!{|x| x.downcase.to_sym }  # make symbols out of the CSV headers
    csv_array.each do |row|               #    convert each data row into a hash, given the CSV headers
      result << Hash[ headerA.zip(row) ]  #    you could use HashWithIndifferentAccess here instead of Hash
    end
    return result
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
