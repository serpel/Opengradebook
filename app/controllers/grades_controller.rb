class GradesController < ApplicationController
  # GET /grades
  # GET /grades.xml
  def index
    @grades = Grade.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grades }
    end
  end

  # GET /grades/1
  # GET /grades/1.xml
  def show
    @grade = Grade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @grade }
    end
  end

  # GET /grades/new
  # GET /grades/new.xml
  def new
    @grade = Grade.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @grade }
    end
  end

  # GET /grades/1/edit
  def edit
    @grade = Grade.find(params[:id])
  end

  # POST /grades
  # POST /grades.xml
  def create
    @grade = Grade.new(params[:grade])

    respond_to do |format|
      if @grade.save
        flash[:notice] = 'Grade was successfully created.'
        format.html { redirect_to(@grade) }
        format.xml  { render :xml => @grade, :status => :created, :location => @grade }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @grade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /grades/1
  # PUT /grades/1.xml
  def update
    @grade = Grade.find(params[:id])

    respond_to do |format|
      if @grade.update_attributes(params[:grade])
        flash[:notice] = 'Grade was successfully updated.'
        format.html { redirect_to(@grade) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grade.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1
  # DELETE /grades/1.xml
  def destroy
    @grade = Grade.find(params[:id])
    @grade.destroy

    respond_to do |format|
      format.html { redirect_to(grades_url) }
      format.xml  { head :ok }
    end
  end
end
