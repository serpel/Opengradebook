class PonderationsController < ApplicationController
  # GET /ponderations
  # GET /ponderations.xml
  def index
    @ponderations = Ponderation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ponderations }
    end
  end

  # GET /ponderations/1
  # GET /ponderations/1.xml
  def show
    @ponderation = Ponderation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ponderation }
    end
  end

  # GET /ponderations/new
  # GET /ponderations/new.xml
  def new
    @ponderation = Ponderation.new
    @subjects = Subject.all
    @definitions = GradeDefinition.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ponderation }
    end
  end

  # GET /ponderations/1/edit
  def edit
    @ponderation = Ponderation.find(params[:id])
  end

  # POST /ponderations
  # POST /ponderations.xml
  def create
    @ponderation = Ponderation.new(params[:ponderation])

    respond_to do |format|
      if @ponderation.save
        flash[:notice] = 'Ponderation was successfully created.'
        format.html { redirect_to(@ponderation) }
        format.xml  { render :xml => @ponderation, :status => :created, :location => @ponderation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ponderation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ponderations/1
  # PUT /ponderations/1.xml
  def update
    @ponderation = Ponderation.find(params[:id])

    respond_to do |format|
      if @ponderation.update_attributes(params[:ponderation])
        flash[:notice] = 'Ponderation was successfully updated.'
        format.html { redirect_to(@ponderation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ponderation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ponderations/1
  # DELETE /ponderations/1.xml
  def destroy
    @ponderation = Ponderation.find(params[:id])
    @ponderation.destroy

    respond_to do |format|
      format.html { redirect_to(ponderations_url) }
      format.xml  { head :ok }
    end
  end
end
