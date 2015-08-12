class SchoolReportsController < ApplicationController
  before_filter :login_required, :has_access
  #filter_access_to :all

  def has_access
    privilege = current_user.privileges.map{|p| p.name}
    unless privilege.include?("decroly_school")
      redirect_to :controller => 'user', :action => 'dashboard'
      flash[:notice] = "#{t('flash_msg4')}"
    end
  end
  # GET /school_reports
  # GET /school_reports.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def gradebook_report
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def biweekly_report
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /school_reports/1
  # GET /school_reports/1.xml
  def show
    @school_report = SchoolReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school_report }
    end
  end

  # GET /school_reports/new
  # GET /school_reports/new.xml
  def new
    @school_report = SchoolReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school_report }
    end
  end

  # GET /school_reports/1/edit
  def edit
    @school_report = SchoolReport.find(params[:id])
  end

  # POST /school_reports
  # POST /school_reports.xml
  def create
    @school_report = SchoolReport.new(params[:school_report])

    respond_to do |format|
      if @school_report.save
        flash[:notice] = 'SchoolReport was successfully created.'
        format.html { redirect_to(@school_report) }
        format.xml  { render :xml => @school_report, :status => :created, :location => @school_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /school_reports/1
  # PUT /school_reports/1.xml
  def update
    @school_report = SchoolReport.find(params[:id])

    respond_to do |format|
      if @school_report.update_attributes(params[:school_report])
        flash[:notice] = 'SchoolReport was successfully updated.'
        format.html { redirect_to(@school_report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /school_reports/1
  # DELETE /school_reports/1.xml
  def destroy
    @school_report = SchoolReport.find(params[:id])
    @school_report.destroy

    respond_to do |format|
      format.html { redirect_to(school_reports_url) }
      format.xml  { head :ok }
    end
  end
end
