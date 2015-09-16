class StudentAdditionalGradeFieldsController < ApplicationController
  # GET /student_additional_grade_fields
  # GET /student_additional_grade_fields.xml
  def index
    @student_additional_grade_fields = StudentAdditionalGradeField.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_additional_grade_fields }
    end
  end

  # GET /student_additional_grade_fields/1
  # GET /student_additional_grade_fields/1.xml
  def show
    @student_additional_grade_field = StudentAdditionalGradeField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_additional_grade_field }
    end
  end

  # GET /student_additional_grade_fields/new
  # GET /student_additional_grade_fields/new.xml
  def new
    @student_additional_grade_field = StudentAdditionalGradeField.new
    @schools = School.find_all_by_is_deleted(false)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_additional_grade_field }
    end
  end

  # GET /student_additional_grade_fields/1/edit
  def edit
    @student_additional_grade_field = StudentAdditionalGradeField.find(params[:id])
    @schools = School.find_all_by_is_deleted(false)
  end

  # POST /student_additional_grade_fields
  # POST /student_additional_grade_fields.xml
  def create
    @student_additional_grade_field = StudentAdditionalGradeField.new(params[:student_additional_grade_field])

    respond_to do |format|
      if @student_additional_grade_field.save
        flash[:notice] = 'StudentAdditionalGradeField was successfully created.'
        format.html { redirect_to(@student_additional_grade_field) }
        format.xml  { render :xml => @student_additional_grade_field, :status => :created, :location => @student_additional_grade_field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_additional_grade_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_additional_grade_fields/1
  # PUT /student_additional_grade_fields/1.xml
  def update
    @student_additional_grade_field = StudentAdditionalGradeField.find(params[:id])

    respond_to do |format|
      if @student_additional_grade_field.update_attributes(params[:student_additional_grade_field])
        flash[:notice] = 'StudentAdditionalGradeField was successfully updated.'
        format.html { redirect_to(@student_additional_grade_field) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_additional_grade_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_additional_grade_fields/1
  # DELETE /student_additional_grade_fields/1.xml
  def destroy
    @student_additional_grade_field = StudentAdditionalGradeField.find(params[:id])
    @student_additional_grade_field.destroy

    respond_to do |format|
      format.html { redirect_to(student_additional_grade_fields_url) }
      format.xml  { head :ok }
    end
  end
end
