class QuestionBanksController < ApplicationController
  # GET /question_banks
  # GET /question_banks.json
  def index
    @question_banks = QuestionBank.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @question_banks }
    end
  end

  # GET /question_banks/1
  # GET /question_banks/1.json
  def show
    @question_bank = QuestionBank.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question_bank }
    end
  end

  # GET /question_banks/new
  # GET /question_banks/new.json
  def new
    @question_bank = QuestionBank.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question_bank }
    end
  end

  # GET /question_banks/1/edit
  def edit
    @question_bank = QuestionBank.find(params[:id])
  end

  # POST /question_banks
  # POST /question_banks.json
  def create
    @question_bank = QuestionBank.new(params[:question_bank])

    respond_to do |format|
      if @question_bank.save
        format.html { redirect_to @question_bank, notice: 'Question bank was successfully created.' }
        format.json { render json: @question_bank, status: :created, location: @question_bank }
      else
        format.html { render action: "new" }
        format.json { render json: @question_bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /question_banks/1
  # PUT /question_banks/1.json
  def update
    @question_bank = QuestionBank.find(params[:id])

    respond_to do |format|
      if @question_bank.update_attributes(params[:question_bank])
        format.html { redirect_to @question_bank, notice: 'Question bank was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @question_bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /question_banks/1
  # DELETE /question_banks/1.json
  def destroy
    @question_bank = QuestionBank.find(params[:id])
    @question_bank.destroy

    respond_to do |format|
      format.html { redirect_to question_banks_url }
      format.json { head :ok }
    end
  end
end
