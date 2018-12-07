class GradeDefinitionsController < ApplicationController
  # GET /grade_definitions
  # GET /grade_definitions.xml
  def index
    @grade_definitions = GradeDefinition.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grade_definitions }
    end
  end

  # GET /grade_definitions/1
  # GET /grade_definitions/1.xml
  def show
    @grade_definition = GradeDefinition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @grade_definition }
    end
  end

  # GET /grade_definitions/new
  # GET /grade_definitions/new.xml
  def new
    @grade_definition = GradeDefinition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @grade_definition }
    end
  end

  # GET /grade_definitions/1/edit
  def edit
    @grade_definition = GradeDefinition.find(params[:id])
  end

  # POST /grade_definitions
  # POST /grade_definitions.xml
  def create
    @grade_definition = GradeDefinition.new(params[:grade_definition])

    respond_to do |format|
      if @grade_definition.save
        flash[:notice] = 'GradeDefinition was successfully created.'
        format.html { redirect_to(@grade_definition) }
        format.xml  { render :xml => @grade_definition, :status => :created, :location => @grade_definition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @grade_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /grade_definitions/1
  # PUT /grade_definitions/1.xml
  def update
    @grade_definition = GradeDefinition.find(params[:id])

    respond_to do |format|
      if @grade_definition.update_attributes(params[:grade_definition])
        flash[:notice] = 'GradeDefinition was successfully updated.'
        format.html { redirect_to(@grade_definition) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grade_definition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /grade_definitions/1
  # DELETE /grade_definitions/1.xml
  def destroy
    @grade_definition = GradeDefinition.find(params[:id])
    @grade_definition.destroy

    respond_to do |format|
      format.html { redirect_to(grade_definitions_url) }
      format.xml  { head :ok }
    end
  end
end
