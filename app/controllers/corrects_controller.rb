class CorrectsController < ApplicationController
  # GET /corrects
  # GET /corrects.json
  def index
    @corrects = Correct.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @corrects }
    end
  end

  # GET /corrects/1
  # GET /corrects/1.json
  def show
    @correct = Correct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @correct }
    end
  end

  # GET /corrects/new
  # GET /corrects/new.json
  def new
    @correct = Correct.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @correct }
    end
  end

  # GET /corrects/1/edit
  def edit
    @correct = Correct.find(params[:id])
  end

  # POST /corrects
  # POST /corrects.json
  def create
    @correct = Correct.new(params[:correct])

    respond_to do |format|
      if @correct.save
        format.html { redirect_to @correct, notice: 'Correct was successfully created.' }
        format.json { render json: @correct, status: :created, location: @correct }
      else
        format.html { render action: "new" }
        format.json { render json: @correct.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /corrects/1
  # PUT /corrects/1.json
  def update
    @correct = Correct.find(params[:id])

    respond_to do |format|
      if @correct.update_attributes(params[:correct])
        format.html { redirect_to @correct, notice: 'Correct was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @correct.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corrects/1
  # DELETE /corrects/1.json
  def destroy
    @correct = Correct.find(params[:id])
    @correct.destroy

    respond_to do |format|
      format.html { redirect_to corrects_url }
      format.json { head :ok }
    end
  end
end
