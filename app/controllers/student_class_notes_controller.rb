class StudentClassNotesController < ApplicationController
  # GET /student_class_notes
  # GET /student_class_notes.xml
  def index
    @student_class_notes = StudentClassNote.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_class_notes }
    end
  end

  # GET /student_class_notes/1
  # GET /student_class_notes/1.xml
  def show
    @student_class_note = StudentClassNote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_class_note }
    end
  end

  # GET /student_class_notes/new
  # GET /student_class_notes/new.xml
  def new
    @student_class_note = StudentClassNote.new
    @subjects = Subject.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_class_note }
    end
  end

  # GET /student_class_notes/1/edit
  def edit
    @student_class_note = StudentClassNote.find(params[:id])
  end

  # POST /student_class_notes
  # POST /student_class_notes.xml
  def create
    @student_class_note = StudentClassNote.new(params[:student_class_note])

    respond_to do |format|
      if @student_class_note.save
        flash[:notice] = 'StudentClassNote was successfully created.'
        format.html { redirect_to(@student_class_note) }
        format.xml  { render :xml => @student_class_note, :status => :created, :location => @student_class_note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_class_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_class_notes/1
  # PUT /student_class_notes/1.xml
  def update
    @student_class_note = StudentClassNote.find(params[:id])

    respond_to do |format|
      if @student_class_note.update_attributes(params[:student_class_note])
        flash[:notice] = 'StudentClassNote was successfully updated.'
        format.html { redirect_to(@student_class_note) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_class_note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_class_notes/1
  # DELETE /student_class_notes/1.xml
  def destroy
    @student_class_note = StudentClassNote.find(params[:id])
    @student_class_note.destroy

    respond_to do |format|
      format.html { redirect_to(student_class_notes_url) }
      format.xml  { head :ok }
    end
  end
end
