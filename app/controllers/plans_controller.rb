class PlansController < ApplicationController

  filter_access_to :all
  before_filter :login_required
  # GET /plans
  # GET /plans.xml
  def index
    @plans = Plan.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  # GET /plans/1
  # GET /plans/1.xml
  def show
    begin  
      @id = params[:id].nil? ? 0:params[:id]
      @plan = Plan.find(@id)
      @plan = @plan.nil? ? ([]):@plan
   
      @st = Student.find_all_by_batch_id(@plan.subject.batch, :conditions => {:is_deleted => false}, :order => "lower(gender) asc, lower(first_name) asc, lower(last_name) asc")
      @st = @st.nil? ? ([]):@st

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @plan }
      end
      
    rescue Exception => e
      flash[:notice] = "Error: Something Wrong, was happenig with Plan :" + id.to_s + "\nContact with Admin! Details : " + e.to_s
      redirect_to :controller => "user", :action => "dashboard"
    end
  end

  # GET /plans/new
  # GET /plans/new.xml
  def new
    @plan = Plan.new
    if request.post? and @plan.save
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @plan }
      end
    end
  end

  # GET /plans/1/edit
  def edit
    @plan = Plan.find(params[:id])

    if request.post? and @plan.update_attributes(params[:plan])
      flash[:notice] = "#{t('flash3')}"
      redirect_to :back
    end
  end

  # POST /plans
  # POST /plans.xml
  def create
    begin
      @plan = Plan.new(params[:plan])
      if @plan.examen_1 && @plan.examen_2 && @plan.examen_3 && @plan.examen_4 &&
         @plan.acumulado_1 && @plan.acumulado_2 && @plan.acumulado_3 && @plan.acumulado_4
        total_1 = @plan.examen_1 + @plan.acumulado_1
        total_2 = @plan.examen_2 + @plan.acumulado_2
        total_3 = @plan.examen_3 + @plan.acumulado_3
        total_4 = @plan.examen_4 + @plan.acumulado_4
        if total_1 == 100 and total_2 == 100 and total_3 == 100 and total_4 == 100
          respond_to do |format|
            if @plan.save
              flash[:notice] = 'Ponderacion creada con exito.'
              format.html { redirect_to(@plan) }
              format.xml  { render :xml => @plan, :status => :created, :location => @plan }
            else
              format.html { render :action => "new" }
              format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
            end
          end
        else
          flash[:notice] = 'Ponderacion de parcial excede o es menor que 100 puntos.'
          redirect_to new_subject_ponderation_path(:id=>@plan.subject_id)
        end
      else
        flash[:notice] = 'Ponderacion no puede ser vacia.'
        redirect_to new_subject_ponderation_path(:id=>@plan.subject_id)
      end
    rescue Exception => e
       flash[:notice] = " Error: creating plan, check inputs!"
       redirect_to :controller => "employee", :action => "get_subjects", :status => 303
    end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    begin
    @plan = Plan.find(params[:id])
		h = params[:plan]
		total_1 = h[:examen_1].to_f + h[:acumulado_1].to_f
		total_2 = h[:examen_2].to_f + h[:acumulado_2].to_f
		total_3 = h[:examen_3].to_f + h[:acumulado_3].to_f
		total_4 = h[:examen_4].to_f + h[:acumulado_4].to_f
		if total_1 == 100 and total_2 == 100 and total_3 == 100 and total_4 == 100
		  respond_to do |format|
		    if @plan.update_attributes(params[:plan])
		      flash[:notice] = 'Ponderacion actualizada con exito.'
		      format.html { redirect_to(@plan) }
		      format.xml  { head :ok }
		    else
		      format.html { render :action => "edit" }
		      format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
		    end
		  end
		else
			flash[:notice] = 'Ponderacion de parcial excede o es menor que 100 puntos.'
			render :action => "edit"
		end

    rescue Exception => e
       flash[:notice] = " Error: plan can't be updated!\nDetails: " + e.to_s
       redirect_to :controller => "employee", :action => "get_subjects", :status => 303
    end
  end

  # /plans/preview
  def preview

  end

  def export
      id = params[:id].nil? ? 0:params[:id]
      @plan = Plan.find(id)
      @plan = @plan.nil? ? ([]):@plan

      @st = Student.find_all_by_batch_id(@plan.subject.batch, :conditions => {:is_deleted => false}, :order => "lower(gender) asc, lower(first_name) asc, lower(last_name) asc")
      @st = @st.nil? ? ([]):@st

    respond_to do |format|
      format.html # index.html.erb
      format.csv { render :template => 'plans/show.rhtml' }
      format.xls { render :template => 'plans/show.rhtml' }
      format.xml { render :template => 'plans/show.rhtml' }
    end
  end

  def import2
    if request.post? && params[:file].present?
      file = params[:file].read
      csv_data = get_data_at( CSV.parse( file ), 6, 7, 100 )

      csv_data.each do |data|
        student = Student.find_by_name(data[:student_id])
        subject = Subject.find_by_code(data[:subject_id])

        nota = Nota.find_by_subject_id_and_student_id(data[:subject_id],student.id) || Nota.new
        nota.examen_1 = data[:examen_1].to_f
        nota.examen_2 = data[:examen_2].to_f
        nota.examen_3 = data[:examen_3].to_f
        nota.examen_4 = data[:examen_4].to_f
        nota.acumulado_1 = data[:acumulado_1].to_f
        nota.acumulado_2 = data[:acumulado_2].to_f
        nota.acumulado_3 = data[:acumulado_3].to_f
        nota.acumulado_4 = data[:acumulado_4].to_f
        nota.subject_id = data[:subject_id].to_i unless nota.subject_id.nil?
        nota.student_id = data[:student_id].to_i unless nota.student_id.nil?

        if !nota.save
          if student.nil? && subject.nil?
            flash[:notice] += "invalid student: #{data[:student_id]}, in subject: #{data[:subject_id]}\n"
          else
            flash[:notice] += "invalid student: #{student.full_name}, in #{subject.name}\n"
          end
        end
      end

      #print errors
      if !flash[:notice].to_s.empty?
        redirect_to :back
      end
    end
  end



  require 'spreadsheet'
  def import

    if request.post? && params[:file].present?
      uploaded_io = params[:file]
      filepath = ""
      File.open(Rails.root.join('public', 'uploads', "#{uploaded_io.original_filename}"), 'w') do |file|
        file.write(uploaded_io.read)
        filepath = file.path
      end

      book = Spreadsheet.open filepath
      sheet ||= book.worksheet 0
      sheet.each do |row|
        row[0] = 2
      end
      book.write filepath

      redirect_to :back
    end

  end
  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to(plans_url) }
      format.xml  { head :ok }
    end
  end

  private
  def get_data_at(csv_array, header_row, begin_number, end_number)  # makes arrays of hashes out of CSV's arrays of arrays
    result = []
    return result if csv_array.nil? || csv_array.empty? || begin_number < 0 ||
        end_number < begin_number

    headerA = csv_array.fetch(header_row)
    headerA.map!{|x| x.downcase.to_sym }
    count = 0
    csv_array.each do |row|
      result << Hash[ headerA.zip(row) ] if count >= begin_number and count <= end_number
      count+=1
    end
    return result
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
end
