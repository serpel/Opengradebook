class StudentAdditionalGradeFieldDetailsController < ApplicationController
  # GET /student_additional_grade_field_details
  # GET /student_additional_grade_field_details.xml
  def index
    @student_additional_grade_field_details = StudentAdditionalGradeFieldDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_additional_grade_field_details }
    end
  end

  # GET /student_additional_grade_field_details/1
  # GET /student_additional_grade_field_details/1.xml
  def show
    @student_additional_grade_field_detail = StudentAdditionalGradeFieldDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_additional_grade_field_detail }
    end
  end

  # GET /student_additional_grade_field_details/new
  # GET /student_additional_grade_field_details/new.xml
  def new
    @student_additional_grade_field_detail = StudentAdditionalGradeFieldDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_additional_grade_field_detail }
    end
  end

  # GET /student_additional_grade_field_details/1/edit
  def edit
    @student_additional_grade_field_detail = StudentAdditionalGradeFieldDetail.find(params[:id])
  end

  # POST /student_additional_grade_field_details
  # POST /student_additional_grade_field_details.xml
  def create
    @student_additional_grade_field_detail = StudentAdditionalGradeFieldDetail.new(params[:student_additional_grade_field_detail])

    respond_to do |format|
      if @student_additional_grade_field_detail.save
        flash[:notice] = 'StudentAdditionalGradeFieldDetail was successfully created.'
        format.html { redirect_to(@student_additional_grade_field_detail) }
        format.xml  { render :xml => @student_additional_grade_field_detail, :status => :created, :location => @student_additional_grade_field_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_additional_grade_field_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_additional_grade_field_details/1
  # PUT /student_additional_grade_field_details/1.xml
  def update
    @student_additional_grade_field_detail = StudentAdditionalGradeFieldDetail.find(params[:id])

    respond_to do |format|
      if @student_additional_grade_field_detail.update_attributes(params[:student_additional_grade_field_detail])
        flash[:notice] = 'StudentAdditionalGradeFieldDetail was successfully updated.'
        format.html { redirect_to(@student_additional_grade_field_detail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_additional_grade_field_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_additional_grade_field_details/1
  # DELETE /student_additional_grade_field_details/1.xml
  def destroy
    @student_additional_grade_field_detail = StudentAdditionalGradeFieldDetail.find(params[:id])
    @student_additional_grade_field_detail.destroy

    respond_to do |format|
      format.html { redirect_to(student_additional_grade_field_details_url) }
      format.xml  { head :ok }
    end
  end
end
