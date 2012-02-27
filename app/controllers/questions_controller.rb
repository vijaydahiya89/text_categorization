require 'fileutils'
require 'tokenizer'
require 'rubygems'
require 'pdf-reader'

class QuestionsController < ApplicationController
  
  #1. Parsing the Doc file to Text file
  #2. Identification of Options
  #3. Identification of Questions
  #4. Identification of which options belong to which question
  #5. Identification of correct option
  #6. placing the short answer in the database.
  #  def parse_file(file,tenant_id,user_id,qb_id)
  def parse()
    pdf_convert = system("unoconv -fpdf /home/satsahib/office/parsing_new/public/qcm.doc ")
    image_store = system("pdfimages -j /home/satsahib/office/parsing_new/public/qcm.pdf /home/satsahib/office/parsing_new/app/assets/images/my_images/")
    reader = PDF::Reader.new("/home/satsahib/office/parsing_new/public/qcm.pdf")
    file_path = "/home/satsahib/office/parsing_new/public/qcm.txt"
    reader.pages.each do |page|
      File.open(file_path, "a") { |f| f.write(page.text)
        f.write("\n")}
    end
    #opening the file in the read mode
    file = File.open("public/qcm.txt", "r")
    #tokenizes the file line by line
    tokenizer = Tokenizer::Tokenizer.new
    tokens = Array.new
    while (line = file.gets)
      tokens << tokenizer.tokenize(line)
    end
    #regular expression for question and answer
    question_pattern =  /^\{?\[?\(?\:?[Q0-9-\*#\.\t]+[\)\]\/\.\}:]+[ \t]*[^\n]*$/
    option_pattern =    /^\{?\[?\(?\:?[A-Ea-e-\*#\.\t]+[\)\]\/\.\}:]+[ \t]*[^\n]*$/
    correct_pattern = /^(Ans:|Answer:)+[ \t]*[^\n]*$/
    topic_pattern = /^(Topic:|topic)+[ \t]*[^\n]*$/
    sub_topic_pattern = /^(Sub-Topic:|Sub-topic:|sub-topic|sub-Topic)+[ \t]*[^\n]*$/
    tag_pattern = /^(Tags:|tags:)+[ \t]*[^\n]*$/
    marks_pattern = /^(Marks:|marks:)+[ \t]*[^\n]*$/
    direction_pattern = /^(Directions:|directions:|direction:|Direction:)+[ \t]*[^\n]*$/
    image_pattern = /^(<img>)$/
    passage_pattern = /^Passage:+[ \t]*[^\n]*$/
    question_bank_pattern = /^(Question-Bank:|Question-bank:|question-bank:)+[ \t]*[^\n]*$/
    @cfi = 0
    @recent_pattern=""
    @to_pattern=""
    @to_pattern1=""
    @to_pattern2=""
    @to_pattern3=""
    @to_pattern4=""
    @to_pattern5=""
    tokens.each { |t|
      unless t.nil? or t.empty?
        diff1=[".",":",")","}","]"]
        diff2=["[","{","("]
        seprator1(t,diff1)
        seprator2(t,diff2)
        option = t
        option = t.join(" ")
        #Finding out whether it is a question or an answer
        if topic_pattern.match(option)
          topic_parser(option)
        elsif image_pattern.match(option)
          parser_image(option)
        elsif direction_pattern.match(option)
          @is_passage_question = false
          direction_parser(option)
        elsif marks_pattern.match(option)
          marks_parser(option)
        elsif tag_pattern.match(option)
          tag_parser(option)
        elsif sub_topic_pattern.match(option)
          subtopic_parser(option)
        elsif option_pattern.match(option)
          option_parser(option)
        elsif passage_pattern.match(option)
          passage_parser(option)
        elsif question_bank_pattern.match(option)
          question_bank_parser(option)
        elsif question_pattern.match(option)
          question_parser(option)
          if (@m_d == "t") and (@is_passage_question == true)
            if @direction_diff > 0
              save_multi_direction_of_passage_and_question_type_for_vijay()
              @direction_diff = @direction_diff - 1
            end

          elsif (@m_d == "t") and (@is_passage_question == false)

            if @direction_diff > 0
              save_multi_direction_for_vijay()
              @direction_diff = @direction_diff - 1
            end

          elsif @m_d == "f"
            save_single_direction_for_vijay()
            @direction_single=""
          else
            save_no_direction_for_vijay()
          end

        elsif correct_pattern.match(option)
          correct_pattern_parser(option)
        else
          if @recent_pattern == "q"
            @concat_question = @recent_question_pattern + " " + option
            save_concat_question_for_vijay()
          end

          if @recent_pattern == "a"
            @recent_pattern_option = @recent_pattern_option+" "+ option
            save_concat_answer_for_vijay()
          end

          if @recent_pattern == "p"
            @recent_pattern_passage = @recent_pattern_passage+"\n"+option
            save_concat_passage_for_vijay()
          end

          if @recent_pattern == "md"
            @recent_pattern_multi_direction = @recent_pattern_multi_direction+" "+option
            save_md_for_vijay()
          end

          if @recent_pattern == "sd"
            @recent_pattern_single_direction = @recent_pattern_single_direction+" "+option
            save_sd_for_vijay()
          end

        end

      end
    }
    
  end


  def seprator1(t, seprate)
    #logger.info"ARRAY in separator 1 #{t.inspect}"
    seprate.each do |s|
      if t.include? s
        #logger.info". included"
        index = t.index(s) - 1
        t[index] = t[index]+s
        t[index+1] = ""
      end
    end

  end

  def seprator2(t, seprate)
    #logger.info"ARRAY in separator 2 #{t.inspect}"
    seprate.each do |s|
      if t.include? s
        #logger.info"my_seprator_included"
        index = t.index(s)+1
        t[index-1] = s+t[index]
        t[index] = ""
        #logger.info"index_position#{t[index].inspect}"

      end
    end
  end

  def tokenize_option(question,a,b,c,d,e)
    #to update the question table attribute "ans_status" to "ans"
    save_ans_status_to_ans_for_vijay(question)
    if !a.nil?
      aa = a.strip
    end
    if !b.nil?
      bb = b.strip
    end
    if !c.nil?
      cc = c.strip
    end
    if !d.nil?
      dd = d.strip
    end
    if !e.nil?
      ee = e.strip
    end
    tokenizer = Tokenizer::Tokenizer.new
    op = Answer.find_all_by_question_id(question.id)
    correct_count = 0
    op.each do |o|
      opt = o.answer
      to = tokenizer.tokenize(opt)
      if to[0]== aa or to[1]==aa
        ans = Answer.find(o.id)
        save_status_correct_for_option_vijay(ans)
        correct_count = correct_count + 1
      end

      if to[0]== bb or to[1]==bb
        ans = Answer.find(o.id)
        save_status_correct_for_option_vijay(ans)
        correct_count = correct_count + 1
      end

      if to[0]== cc or to[1]==cc
        ans = Answer.find(o.id)
        save_status_correct_for_option_vijay(ans)
        correct_count = correct_count + 1
      end

      if to[0]== dd or to[1]==dd
        ans = Answer.find(o.id)
        save_status_correct_for_option_vijay(ans)
        correct_count = correct_count + 1
      end
      
      if to[0]== ee or to[1]==ee
        ans = Answer.find(o.id)
        save_status_correct_for__option_vijay(ans)
        correct_count = correct_count + 1
      end

    end

    if (correct_count == 1) and (question.passage_id.nil?)
      save_question_type_mcq_for_vijay(question)
     
    elsif (correct_count > 1 ) and (question.passage_id.nil?)
      save_question_type_maq_for_vijay(question)
    end

  end


  def save_sa_tff(que,ans)
    #to update the question table attribute "ans_status" to "ans"
    save_ans_status_of_save_for_vijay(que)
    fib_check = /___*/

    if fib_check.match(que.question) and (que.passage_id.nil?)
      save_question_type_fib_for_vijay(que)
    elsif  (que.passage_id.nil?)
      save_question_type_sa_for_vijay(que)
    end
    
    answer = Answer.new
    answer.answer = ans[0]
    answer.question_id = que.id
    answer.status = "correct"
    save_answer(ans[0],"correct")
    answer.save
  end

  def save_answer(answer,status)
    answer = Answer.new
    answer.answer = answer
    answer.status = status
    answer.save
  end

  def image_parser
    #this parser goes to the directory where the images are getting saved and take each file and delete
    #the ". , .." files of the directory.
    image_files = Array.new
    #Giving the path of the directory where the images being saved.
    d = Dir.new("/home/satsahib/office/parsing_new/app/assets/images/my_images")
    d.each { |file|
      image_files << file
    }
    image_files.delete(".")
    image_files.delete("..")
    return image_files
  end

  def topic_parser(opt)
    #1st feb 2012 Matching the topic  pattern and storing it in the topics table
    deleted_topic = opt.slice!("Topic: ")
    deleted_topic = opt.slice!("topic:")
    deleted_topic1 = opt.strip
    topic_parser_save_vijay(deleted_topic1)
  end

  

  def marks_parser(opt)
    deleted_marks = opt.slice!("Marks: ")
    deleted_marks = opt.slice!("marks:")
    deleted_marks1 = opt.strip
    @marks_tag = deleted_marks1.split(',')
  end

  def tag_parser(opt)
    #this parser gets the parses the tags which are given
    # by the user for difficulty, positive_id, negative_id
    deleted_tag = opt.slice!("Tags: ")
    deleted_tag = opt.slice!("tags:")
    deleted_tag1 = opt.strip
    deleted_tag2 = deleted_tag1.split(',')
    difficulty = deleted_tag2[0]
    positive_id = deleted_tag2[1]
    negative_id = deleted_tag2[2]
    tag_parser_save_vijay(difficulty, positive_id, negative_id)
  end

  def question_bank_parser(opt)
    deleted_question_bank = opt.slice!("Question-bank:")
    deleted_question_bank = opt.slice!("Question-Bank:")
    deleted_question_bank = opt.slice!("question-bank:")
    question_bank_name = opt.strip
    question_bank_parser_save_vijay(question_bank_name)
  end
  
  def passage_parser(opt)
    @recent_pattern=""
    @recent_pattern_passage=""
    passage_parser_save_vijay(opt)
  end

  def  subtopic_parser(opt)
    #1st feb 2012 Matching the sub_topic pattern  and storing it in the subtopics table
    deleted_subtopic = opt.slice!("Sub-Topic: ")
    deleted_subtopic = opt.slice!("Sub-topic: ")
    deleted_subtopic = opt.slice!("sub-Topic: ")
    deleted_subtopic = opt.slice!("sub-topic: ")
    deleted_subtopic1 = opt.strip
    subtopic_parser_save_vijay(deleted_subtopic1)
  end

  def option_parser(opt)
    @recent_pattern=""
    @recent_pattern_option=""
    @answer_copy=""
    #matching the question pattern
    option_parser_save_vijay(opt)
  end

  def question_parser(opt)
    delete_question_part = /\{?\[?\(?\:?[Q0-9-\*#\.\t]+[\)\]\/\.\}:][ \t]*/
    @recent_pattern = ""
    @recent_question_pattern=""
    #matching the answer pattern
    #Now that we hit an option pattern, what ever we have read till now is a question and so save it in question table.
    #This part is for deleting the Q1... part of the Question.....
    if  delete_question_part.match(opt)
      res = delete_question_part.match(opt)[0]
      opt.slice!(res)
      question_parser_save_vijay(opt)
      @recent_que = "1"
      @recent_pattern = "q"
      @recent_question_pattern = @question.question
    end
  end

  def correct_pattern_parser(opt)
    @deleted_answer=""
    @deleted_answer = opt.slice!("Ans: ")
    @deleted_answer = opt.slice!("Answer: ")
    @deleted_answer1 = opt
    @to_answer = @deleted_answer1.split(',')
    @to_answer1 = @to_answer[0]
    @to_answer2 = @to_answer[1]
    @to_answer3 = @to_answer[2]
    @to_answer4 = @to_answer[3]
    @to_answer5 = @to_answer[4]
    if @to_answer.count == 1 and @to_answer[0].strip.length > 1
      save_sa_tff(@question,@to_answer)
    else
      tokenize_option(@question,@to_answer1,@to_answer2,@to_answer3,@to_answer4,@to_answer5)
    end
  end

  def direction_parser(opt)
    @recent_pattern = ""
    @recent_pattern_multi_direction = ""
    @recent_pattern_single_direction = ""
    direction_pattern1 = /([0-9]*-[0-9]*)/
    @deleted_direction = opt.slice!("Directions: ")
    @deleted_direction = opt.slice!("directions:")
    @deleted_direction = opt.slice!("direction:")
    @deleted_direction = opt.slice!("Direction:")
    @direction = opt.strip
    #trying to write the code for all kind of directions
    if  direction_pattern1.match(@direction)
      res = direction_pattern1.match(@direction)[0]
      res1 = res.split('-')
      res2 = res1[1].to_i-res1[0].to_i
      @direction_diff = res2 + 1
      @direction_multi = @direction
      @recent_pattern_multi_direction = @direction_multi
      @m_d = "t"
      @recent_pattern="md"
    else
      @m_d = "f"
      @direction_single = @direction
      @recent_pattern_single_direction = @direction_single
      @recent_pattern = "sd"
    end
  end

  def parser_image(opt)
    #this parser is paring down the image.
    path_image = "/assets/my_images/"
    x = Array.new
    x = image_parser()
    parser_image_save_vijay(x, path_image)
  end

  def ans_check
    @question = Question.find_by_ans_status("no_ans")
  end

  #VIJAY METHODS

  def save_sd_for_vijay()
    @question.update_attribute(:direction,@recent_pattern_single_direction)
  end

  def save_md_for_vijay()
    @question.update_attribute(:direction,@recent_pattern_multi_direction)
  end

  def save_multi_direction_of_passage_and_question_type_for_vijay()
    @question.update_attribute(:direction,@direction_multi)
    @question.update_attribute(:passage_id,@passage.id)
    @question.update_attribute(:question_type, "PTQ")
  end

  def save_multi_direction_for_vijay()
    @question.update_attribute(:direction,@direction_multi)
  end

  def save_single_direction_for_vijay()
    @question.update_attribute(:direction,@direction_single)
  end

  def save_no_direction_for_vijay()
    @question.update_attribute(:direction,"")
  end

  def save_concat_question_for_vijay()
    @question.update_attribute(:question,@concat_question)
  end

  def save_concat_answer_for_vijay()
    @answer.update_attribute(:answer, @recent_pattern_option)
  end

  def save_concat_passage_for_vijay()
    @passage.update_attribute(:passage, @recent_pattern_passage)
  end

  def save_question_type_maq_for_vijay(question)
    question.update_attribute(:question_type, "MAQ")
  end

  def save_question_type_mcq_for_vijay(question)
    question.update_attribute(:question_type, "MCQ")
  end

  def save_status_correct_for_option_vijay(ans)
    ans.update_attribute(:status, "correct")
  end
  
  def save_ans_status_of_save_for_vijay(que)
    que.update_attribute(:ans_status, "ans")
  end

  def save_question_type_fib_for_vijay(que)
    que.update_attribute(:question_type, "FIB")
  end

  def save_question_type_sa_for_vijay(que)
    que.update_attribute(:question_type, "SA")
  end

  def tag_parser_save_vijay(difficulty, positive_id, negative_id)
    @question.difficulty_id = difficulty
    @question.positive_id = positive_id
    @question.negative_id = negative_id
    @question.save
  end

  def save_ans_status_to_ans_for_vijay(question)
    question.update_attribute(:ans_status, "ans")
  end
  
  def topic_parser_save_vijay(topic)
    @topic = Topic.new
    @topic.topic = topic
    @topic.save
  end

  def question_bank_parser_save_vijay(question_bank_name)
    @question_bank = QuestionBank.new
    @question_bank.name = question_bank_name
    @question_bank.save
  end

  def passage_parser_save_vijay(opt)
    @passage = Passage.new
    @passage.passage = opt
    @passage.save
    @recent_pattern_passage=opt
    @recent_pattern = "p"
    @is_passage_question = true
  end

  def subtopic_parser_save_vijay(subtopic)
    @subtopic = Subtopic.new
    @subtopic.subtopic = subtopic
    @subtopic.topic_id = @topic.id
    @subtopic.save
  end

  def option_parser_save_vijay(opt)
    @answer = Answer.new
    @answer.answer = opt
    @answer.question_id = @question.id
    @answer_copy = @answer.answer
    @answer.save
    @recent_pattern = "a"
    @recent_pattern_option = @answer.answer
  end

  def question_parser_save_vijay(opt)
    @question = Question.new
    @question.question = opt
    @question.topic_id = @topic.id
    @question.subtopic_id = @subtopic.id
    @question.positive_id = @marks_tag[0]
    @question.negative_id = @marks_tag[1]
    @question.questionbank_id = @question_bank.id
    @question.save
  end

  def parser_image_save_vijay(x, path_image)
    # feb 3rd doing the image parsing and placing it in the database along with the question_id and answer_id
    @image = Image.new
    for i in 1 .. 1
      @image.name = x[@cfi]
      @image.path = path_image + @image.name
    end

    if @question.id == @answer.question_id
      @image.question_id = 0
      @image.answer_id = @answer.id
      @image.save
    else

      @image.question_id = @question.id
      @image.answer_id = 0
      @image.save
    end
    @cfi = @cfi +1
  end

  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.xml
  def create
    @question = Question.new(params[:question])
    respond_to do |format|
      if @question.save
        flash[:notice] = 'Question was successfully created.'
        format.html { redirect_to(@question) }
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question = Question.find(params[:id])
    respond_to do |format|
      if @question.update_attributes(params[:question])
        flash[:notice] = 'Question was successfully updated.'
        format.html { redirect_to(@question) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @question = Question.find(:all)
    @question.each do |q|
      q.destroy
    end
  end

  def preview
    #    @topic = Topic.find(:all)
    @questions = Question.find(:all)
   
    #    @answer = Answer.find(:all)
    #    @image = Image.find(:all)
    #    @subtopic = Subtopic.find(:all)
  end

  def destroy_all
    @question = Question.find(:all)
    @question.each do |q|
      q.destroy
    end
    @answer = Answer.find(:all)
    @answer.each do |a|
      a.destroy
    end

    @image = Image.find(:all)
    @image.each do |q|
      q.destroy
    end

    @topic = Topic.find(:all)
    @topic.each do |q|
      q.destroy
    end
    @subtopic = Subtopic.find(:all)
    @subtopic.each do |q|
      q.destroy
    end
    @passage = Passage.find(:all)
    @passage.each do |q|
      q.destroy
    end
    @question_bank = QuestionBank.find(:all)
    @question_bank.each do |q|
      q.destroy
    end

    redirect_to("/questions")
  end

  def delete_left_answer
    new_answer = Array.new
    delete_answer_part = /^\{?\[?\(?\:?[A-Ea-e-\*#\.\t]+[\)\]\/\.\}:]+[ \t]*/
    @answers = Answer.find(:all)
    @answers.each do |a|
      if  delete_answer_part.match(a.answer)
        res = delete_answer_part.match(a.answer)[0]
        a.answer.slice!(res)
        new_answer << a.answer
      end
    end
  end

  def parse_new
    pdf_convert = system("unoconv -fpdf /home/satsahib/office/parsing_new/public/qcm.doc ")
    image_store = system("pdfimages -j /home/satsahib/office/parsing_new/public/qcm.pdf /home/satsahib/office/parsing_new/app/assets/images/my_images/")
    reader = PDF::Reader.new("/home/satsahib/office/parsing_new/public/qcm.pdf")
    file_path = "/home/satsahib/office/parsing_new/public/qcm.txt"
    reader.pages.each do |page|
      File.open(file_path, "a") { |f| f.write(page.text)
        f.write("\n")}
    end
  end

end