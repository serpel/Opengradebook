class NotasController < ApplicationController
  # GET /notas
  # GET /notas.xml
  def index
    @notas = Nota.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notas }
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
        flash[:notice] = 'Alumno calificado con exito.'
				redirect_to ("/plans/"+@plan.id.to_s) 
      else
				flash[:notice] = 'Something went wrong when updating score.'
				render :action => "edit" 
      end
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
