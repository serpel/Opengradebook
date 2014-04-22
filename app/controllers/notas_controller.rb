class NotasController < ApplicationController
  require 'csv'
  
  # GET /notas
  # GET /notas.xml
  def index
    @notas = Nota.find 14

    respond_to do |format|
      format.html # index.html.erb
      format.csv  { render :text => @notas.to_csv }
    end
  end

  # GET /notas/1
  # GET /notas/1.xml
  def show
    @nota = Nota.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  # GET /notas/new
  # GET /notas/new.xml
  def new
    @nota = Nota.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nota }
    end
  end

  # GET /notas/1/edit
  def edit
    @nota = Nota.find(params[:id])
  end

  # POST /notas
  # POST /notas.xml
  def create
    @nota = Nota.new(params[:nota])
		@plan = Plan.find_by_subject_id(@nota.subject_id)
		if !@nota.examen_1
			@nota.examen_1 = 0.0
		end
		if !@nota.examen_2
			@nota.examen_2 = 0.0
		end
		if !@nota.examen_3
			@nota.examen_3 = 0.0
		end
		if !@nota.examen_4
			@nota.examen_4 = 0.0
		end

		if !@nota.acumulado_1
			@nota.acumulado_1 = 0.0
		end
		if !@nota.acumulado_2
			@nota.acumulado_2 = 0.0
		end
		if !@nota.acumulado_3
			@nota.acumulado_3 = 0.0
		end
		if !@nota.acumulado_4
			@nota.acumulado_4 = 0.0
		end
		
		if @nota.examen_1 > @plan.examen_1 || @nota.examen_2 > @plan.examen_2 ||
			 @nota.examen_3 > @plan.examen_3 || @nota.examen_4 > @plan.examen_4 ||
       @nota.acumulado_1 > @plan.acumulado_1 || @nota.acumulado_2 > @plan.acumulado_2 ||
			 @nota.acumulado_3 > @plan.acumulado_3 || @nota.acumulado_4 > @plan.acumulado_4
			flash[:notice] = 'La calificacion no puede ser mayor que los valores de ponderacion.'
			redirect_to new_student_score_path(:id => @nota.subject_id, :id2 => @nota.student_id)
		else
			if @nota.save
        current_subject = Subject.find(@nota.subject_id)
        sender = current_user.email
        student = Student.find(@nota.student_id, :conditions => {:is_deleted => false})
        guardians = student.guardians.compact.uniq

        to = []
        to.push student.email
        to.concat guardians
        to.compact!

        #to << student.email unless student == nil
        #to << guardians.map{ |g| g.email }.select{ |s| !s.empty? }.uniq unless guardians == nil
        #to.reject! { |i| i.empty? or i.nil? }

        subject = "#{t('gradebook_published')} - " + current_subject.name
        body = "#{t('grade_text')},\r\n" + "#{t('assigment')}: " + current_subject.name

        if to.count > 0
          Delayed::Job.enqueue(GradebookMailJob.new(sender,to,subject,body))
        end
		    flash[:notice] = 'Alumno calificado con exito.'
				redirect_to ("/plans/"+@plan.id.to_s) 
		  else
		    flash[:notice] = 'Something went wrong when creating score.'
				render :action => "new"
		  end
		end
  end

  # PUT /notas/1
  # PUT /notas/1.xml
  def update
    @nota = Nota.find(params[:id])
    @plan = Plan.find_by_subject_id(@nota.subject_id)
		h = params[:nota]
		if h[:examen_1].to_f > @plan.examen_1 || h[:examen_2].to_f > @plan.examen_2 || 
			 h[:examen_3].to_f > @plan.examen_3 || h[:examen_4].to_f > @plan.examen_4 ||
			 h[:acumulado_1].to_f > @plan.acumulado_1 || h[:acumulado_2].to_f > @plan.acumulado_2 ||
			 h[:acumulado_3].to_f > @plan.acumulado_3 || h[:acumulado_4].to_f > @plan.acumulado_4
			flash[:notice] = "La calificacion no puede ser mayor que los valores de ponderacion."
			render :action => "edit"
		else
      if @nota.update_attributes(params[:nota])

        #student notification
        current_subject = Subject.find(@nota.subject_id)
        sender = current_user.email
        student = Student.find(@nota.student_id, :conditions => {:is_deleted => false})
        guardians = student.guardians.compact.uniq

        to = []
        to.push student.email
        to.concat guardians.map{ |g| g.email }
        to.compact!
        
        #to << guardians.map{ |g| g.email }.select{ |s| !s.empty?  }.uniq unless guardians == nil
        #to.reject! { |i| i.empty? or i.nil? }
        
        subject = "#{t('gradebook_published')} - " + current_subject.name
        body = "#{t('grade_text')},\r\n" + "#{t('assigment')}: " + current_subject.name
        
        if to.count > 0
          Delayed::Job.enqueue(GradebookMailJob.new(sender,to,subject,body))
        end
        
        flash[:notice] = 'Alumno calificado con exito.'
				redirect_to ("/plans/"+@plan.id.to_s) 
      else
				flash[:notice] = 'Something went wrong when updating score.'
				render :action => "edit" 
      end
		end
  end

  # GET /notas/by_grade/14
  def get_grades_notes
    begin
      @course_id = params[:id].nil? ? 0:params[:id]

      @batch = Batch.active.find(@course_id)
      @batch = @batch.nil? ? ([]):@batch

      @subjects = @batch.subjects
      @subjects = @subjects.nil? ? ([]):@subjects

      @students = Student.find_all_by_batch_id(@batch, :conditions => {:is_deleted => false}, :order => "lower(gender) asc, lower(first_name) asc, lower(last_name) asc")
      @students = @students.nil? ? ([]):@students

      render(:update) { |page| page.replace_html 'students', :partial => 'notes_by_grade' }

    rescue Exception => e
      flash[:notice] = "Error: Something Wrong, 'get_grades_notes': " + @course_id.to_s + "\r\nDetails : " + e.to_s
      redirect_to :controller => "user", :action => "dashboard"
    end
  end

  def by_grade
    begin
      employee = Employee.find_by_employee_number(current_user.username)
      subjects = employee.subjects.select { |s| s.is_deleted == false }
      batche_ids = subjects.map { |a| a.batch_id }.uniq
      batches = Batch.find_all_by_id(batche_ids, :conditions => { :is_deleted => false})
      course_ids = batches.map { |b| b.course_id }.uniq
      @courses = Course.find_all_by_id(course_ids, :conditions => { :is_deleted => false})
    rescue Exception => e
      flash[:notice] = "Error: getting students grades, contact Admin! Details: "+ e.to_s
      redirect_to :controller => "user", :action => "dashboard"
    end
  end

  def export_csv

      course_id = params[:id].nil? ? 0:params[:id]

      @batch = Batch.active.find(course_id)
      @batch = @batch.nil? ? ([]):@batch

      @subjects = @batch.subjects
      @subjects = @subjects.nil? ? ([]):@subjects

      @students = Student.find_all_by_batch_id(@batch, :conditions => {:is_deleted => false}, :order => "lower(gender) asc, lower(first_name) asc, lower(last_name) asc")
      @students = @students.nil? ? ([]):@students

    respond_to do |format|
      format.html # index.html.erb
      format.xls { render :template => 'notas/show.rhtml',:name => 'test' }
      format.pdf { render :template => 'notas/show.rhtml' }
    end
  end

  # DELETE /notas/1
  # DELETE /notas/1.xml
  def destroy
    @nota = Nota.find(params[:id])
    @nota.destroy

    respond_to do |format|
      format.html { redirect_to(notas_url) }
      format.xml  { head :ok }
    end
  end
end
