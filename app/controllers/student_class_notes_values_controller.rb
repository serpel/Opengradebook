class StudentClassNotesValuesController < ApplicationController
  # GET /student_class_notes_values
  # GET /student_class_notes_values.xml
  def index
    @student_class_notes_values = StudentClassNotesValue.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_class_notes_values }
    end
  end

  # GET /student_class_notes_values/1
  # GET /student_class_notes_values/1.xml
  def show
    @student_class_notes_value = StudentClassNotesValue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_class_notes_value }
    end
  end

  # GET /student_class_notes_values/new
  # GET /student_class_notes_values/new.xml
  def new
    @student_class_notes_value = StudentClassNotesValue.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_class_notes_value }
    end
  end

  # GET /student_class_notes_values/1/edit
  def edit
    @student_class_notes_value = StudentClassNotesValue.find(params[:id])
  end

  # POST /student_class_notes_values
  # POST /student_class_notes_values.xml
  def create
    @student_class_notes_value = StudentClassNotesValue.new(params[:student_class_notes_value])

    respond_to do |format|
      if @student_class_notes_value.save
        flash[:notice] = 'StudentClassNotesValue was successfully created.'
        format.html { redirect_to(@student_class_notes_value) }
        format.xml  { render :xml => @student_class_notes_value, :status => :created, :location => @student_class_notes_value }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_class_notes_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_class_notes_values/1
  # PUT /student_class_notes_values/1.xml
  def update
    @student_class_notes_value = StudentClassNotesValue.find(params[:id])

    respond_to do |format|
      if @student_class_notes_value.update_attributes(params[:student_class_notes_value])
        flash[:notice] = 'StudentClassNotesValue was successfully updated.'
        format.html { redirect_to(@student_class_notes_value) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_class_notes_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_class_notes_values/1
  # DELETE /student_class_notes_values/1.xml
  def destroy
    @student_class_notes_value = StudentClassNotesValue.find(params[:id])
    @student_class_notes_value.destroy

    respond_to do |format|
      format.html { redirect_to(student_class_notes_values_url) }
      format.xml  { head :ok }
    end
  end
end
