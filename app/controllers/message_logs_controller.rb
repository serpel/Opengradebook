class MessageLogsController < ApplicationController
  # GET /message_logs
  # GET /message_logs.xml
  def index
    @message_logs = MessageLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_logs }
    end
  end

  # GET /message_logs/1
  # GET /message_logs/1.xml
  def show
    @message_log = MessageLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_log }
    end
  end

  # GET /message_logs/new
  # GET /message_logs/new.xml
  def new
    @message_log = MessageLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_log }
    end
  end

  # GET /message_logs/1/edit
  def edit
    @message_log = MessageLog.find(params[:id])
  end

  # POST /message_logs
  # POST /message_logs.xml
  def create
    @message_log = MessageLog.new(params[:message_log])

    respond_to do |format|
      if @message_log.save
        flash[:notice] = 'MessageLog was successfully created.'
        format.html { redirect_to(@message_log) }
        format.xml  { render :xml => @message_log, :status => :created, :location => @message_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /message_logs/1
  # PUT /message_logs/1.xml
  def update
    @message_log = MessageLog.find(params[:id])

    respond_to do |format|
      if @message_log.update_attributes(params[:message_log])
        flash[:notice] = 'MessageLog was successfully updated.'
        format.html { redirect_to(@message_log) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /message_logs/1
  # DELETE /message_logs/1.xml
  def destroy
    @message_log = MessageLog.find(params[:id])
    @message_log.destroy

    respond_to do |format|
      format.html { redirect_to(message_logs_url) }
      format.xml  { head :ok }
    end
  end
end
