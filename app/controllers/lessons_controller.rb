class LessonsController < ApplicationController

#  before_action :authenticate_user!, except: [:index, :show]
  skip_before_action :verify_authenticity_token

  before_action :set_lesson, only: [:show, :activity]
  before_action :set_contexts, only: [:index, :edit]
  before_action :set_subjects, only: [:index, :edit]
  before_action :set_collections, only: [:index, :edit]



  def index
    # Using lessons#index for now as the public view of all lesson
    # No authentication heres

    # Fetch the page number, otherwise 1
    @page = params[:page] || 1

    # Fetch lessons
    @lessons = Lesson.includes(:steps).page(@page)

    # TODO: use filters

    # Fetch subjects
    @filter_subjects = [] # TODO: turn subject param into array to check against

    # set difficulties
    @difficulty_helper = MasteryLevel.form_helper

    # Pagination stub, just so i can style the output - DH
    @paginatable_array = Kaminari.paginate_array([*1..280]).page(params[:page]).per(12)

  end

  def show

    # TODO: just finding/creating a dummy lesson now just to be able to show the templates
    #@lesson = Lesson.includes(:steps).find(params[:id])
    @lesson_obj = LessonService.find_or_create_and_update(params[:id], nil, current_user)
    @lesson_obj.steps << Step.new(summary: "")

    # Fetch any specified section and turn it into a sym, otherwise :overview
    @section = params[:section].present? ? params[:section].to_sym : :overview

  end

  def new

    # We only need to create a new empty lesson with an id here
    # before handing it off to edit. An id might have been provided already.
    # TODO: look up a lesson that in the middle of being created, by session id
    lesson = LessonService.find_or_create_and_update(params[:id], nil, current_user)
    lesson.steps << Step.new(summary: "")

    if lesson.present?
      redirect_to edit_lesson_path(lesson)
    else
      raise lesson.errors
    end

  end

  def edit

    @current_user = current_user

    # Assign the @form_step var, casting as integer instead of a string
    @form_step = params[:form_step].present? ? params[:form_step].to_i : 1
    @lesson_obj = Lesson.find(params[:id])


    #pundit --
    authorize @lesson_obj, :update? # TODO: this keeps erroring for me - DH

    # If the form step is 2, i.e. standards, we redirect to create the first standard
    redirect_to new_lesson_standard_path(lesson_id: @lesson_obj.id, form_step: @form_step) if @form_step == 2

    # If the form step is 4, i.e. steps, we redirect to edit the first step created
    # when the lesson itself was created
    if @form_step == 4
      @steps = @lesson_obj.steps.order(:created_at).to_a
      unless @steps.present?
        @lesson_obj.steps << Step.new(summary: "")
        @lesson_obj.save!
        puts @lesson_obj.steps
        @steps = @lesson_obj.steps.to_a
      end
      @steps_array = @steps.map{|s| s.id}

      redirect_to edit_lesson_step_path(lesson_id: @lesson_obj.id, id: @lesson_obj.steps.first.id, form_step: @form_step)
    end




    if params[:lesson].present?
      @lesson_obj = LessonService.find_or_create_and_update(params[:id], lesson_params, @current_user)
    end
    files_hash = {}
    files_hash.merge!({assessment_criteria_files: params[:assessment_criteria_files]}) if params[:assessment_criteria_files].present?
    files_hash.merge!({outcome_files: params[:outcome_files]}) if params[:outcome_files].present?

    LessonService.add_file_by_type_to_id(@lesson_obj.id, files_hash) # should not be user first
    @lesson_obj.reload

    # elsif params[:id].present? && params[:step].present? # making a step
    #   Step.find_or_create_and_update(nil, params[:id], step_param, User.first).set_files(params)

    #@collections = CollectionTag.all.to_a.map{|x| x.name.titleize}
    @collections = CollectionTag.all
    @difficulty_helper = MasteryLevel.form_helper
    @teaching_range_helper = TeachingRange.inputRange

  end


  def update

    #raise params.to_yaml

    #print params.inspect

    puts params.inspect
    puts "lesson_params hereeeeee"
    puts lesson_params.inspect

    puts lesson_params[:tags]

    # Update the lesson
    @lesson_obj = LessonService.find_or_create_and_update(params[:id], lesson_params, User.first)
    # @lesson_obj.setTags(lesson_params[:tags])
    # puts @lesson_obj.tags

    # Redirect to the next step
    redirect_to edit_lesson_path(id: @lesson_obj.id, form_step: params[:form_step])

  end

  def upload_file_____________!

    # Dropzones submit the file here

    # Fetch the lesson by the provided id
    @lesson_obj = Lesson.find(params[:id])

    # The submitted file: multipe files can be uploaded so this will be an array
    file = params[:files]


    # The attribute in which file should be stored (an array atribute)
    # for example, 'assessment_criteria_files'
    attribute = params[:attribute]

    files_hash = {}
    files_hash.merge!({assessment_criteria_files: params[:assessment_criteria_files]}) if params[:assessment_criteria_files].present?
    files_hash.merge!({outcome_files: params[:outcome_files]}) if params[:outcome_files].present?

    LessonService.add_file_by_type_to_id(@lesson_obj.id, files_hash)

    # TODO: add the file to the lesson via the attribute provided

    # Return the attribute as json
    render :json => @lesson_obj.send(attribute)

  end

  def delete_file

    # Fetch the lesson by the provided id
    @lesson_obj = Lesson.find(params[:id])

    # The file name to be deleted
    file_name = params[:file_name]

    # The attribute from which file should be remove
    # for example, 'assessment_criteria_files'
    attribute = params[:attribute]

    # TODO: remove the specified file and update the lesson

    # Return the attribute as json
    render :json => @lesson_obj.send(attribute)

  end



  def publish
    # check to make sure current user is owner and make inactive
    # make sure passes validation
    render :json => {success: Lesson.find(params[:id]).publish!}, :status => 200
  end

  def delete

    lesson = Lesson.find(params[:id]).hidden!

    redirect_to edit_lesson_path(id: lesson.id)

  end

  def add_step
    @lesson = Lesson.first
    id = nil
    id = step_param[:id] if step_param[:id].present? # updates
    @step = Step.find_or_create_and_update(id, params[:id], step_param, User.first).set_files(params) # should not be user first
    render :json => {success: "OKEY", lesson: @step.id}, :status => 200
  end

  def delete_step
    r = Step.delete_and_update_sibilings(params[:step_id], params[:id], User.first) # should not be user first
    render :json => {success: r}, :status => 200
  end

  # ~~~~~~~~~~~~~~~
  # STEPS HERE
  # ~~~~~~~~~~~~~~~
  def set_steps
    step_params[:steps].map{|s|
      id = nil
      puts s.inspect
      id = s[:id] if s[:id].present?
      Step.find_or_create_and_update(id, params[:id], s, User.first).id # should not be user first
    }
    ids = Lesson.find(params[:id]).steps.order(:created_at).map{|x| x.id}
    render :json => {ids: ids}, :status => 200
  end
  def remove_step
    Step.delete_and_update_sibilings(step_param[:id], params[:id], User.first) # should not be user first
    ids = Lesson.find(params[:id]).steps.order(:created_at).map{|x| x.id}
    render :json => {ids: ids}, :status => 200
  end

  def draft

  end

  def upload_file
    @lesson = Lesson.find(params[:id])

    # TODO - AUTHORIZE USER!!!!!
    puts params[:files]
    # puts file_params.inspect

    files = [params[:files]]
    #files = file_params[:files]
    # TODO - check to make sure you are uploading file in array

    files_hash = {}
    files_hash.merge!({assessment_criteria_files: files}) if params[:attr] == "assessment_criteria_files"
    files_hash.merge!({outcome_files: files}) if file_params[:attr] == "outcome_files"
    # puts "uploading files"
    # puts files_hash.inspect

    files_hash = {assessment_criteria_files: files}

    #LessonService.add_file_by_type_to_id(@lesson.id, files_hash)
    @lesson.reload

    returning = []
    puts files_hash.inspect


    if files_hash[:assessment_criteria_files].present?
      print "RUNNING"
      uploaded_acf = files.each{|x|
        @lesson.find_carrier_wave_with_original_name(x.original_filename, :assessment_criteria)
      }
      for i in 0..uploaded_acf.count-1
        x = @lesson.assessment_criteria_files[i]
        @lesson.reload
        returning.push( JqUploaderService.convert_to_jq_upload(x, @lesson.id, "assessment_criteria") )
      end
    elsif files_hash[:outcome_files].present?
      uploaded_of = files.each{|x|
        @lesson.find_carrier_wave_with_original_name(x.original_filename, :outcome_files)
      }
      puts uploaded_of.count
      for i in 0..uploaded_of.count-1
        @lesson.reload
        x = @lesson.outcome_files[i]
        returning.append (JqUploaderService.convert_to_jq_upload(x, @lesson.id, "outcome") )
      end
    end


    respond_to do |format|
      format.html {
        render :json => returning.to_json,
               :content_type => 'text/html',
               :layout => false
      }
      format.json {
        render :json => { :files => returning }
      }
    end
  end

  def file_upload_load
    @lesson = Lesson.find(params[:id])
    returning = []
    if file_params[:attr] == "assessment_criteria_files"
        @lesson.assessment_criteria_files.map{|x|
          returning.push( JqUploaderService.convert_to_jq_upload(x, @lesson.id, "assessment_criteria") )
        }
    elsif
      file_params[:attr] == "outcome_files"
        @lesson.outcome_files.map{|x|
          returning.push( JqUploaderService.convert_to_jq_upload(x, @lesson.id, "outcome") )
        }
    end

    respond_to do |format|
      format.html {
        render :json => returning.to_json,
               :content_type => 'text/html',
               :layout => false
      }
      format.json {
        render :json => { files: returning }, status: :created, location: @Uploaded
      }
    end
  end

  def remove_file_upload
    puts "prepping for delete"
    puts params.inspect
    @lesson = Lesson.find(params[:id])
    status = @lesson.removeFileWithName(remove_file_params[:attr].to_sym, remove_file_params[:name])
    puts "finished for delete"
    render :json => {status: status}, location: @Uploaded
  end



  # STEP FILES HERE
  def step_file_upload_load
    @lesson = Lesson.find(params[:id])
    @step = @lesson.steps.find(params[:step])

    returning = []

    if file_params[:attr] == "supporting_files"
      @step.supporting_files.map{|x|
        returning.push( JqUploaderService.convert_to_jq_upload_step(x, @lesson.id, @step.id, "supporting_files") )
      }
    elsif
    file_params[:attr] == "supporting_materials"
      @step.supporting_materials.map{|x|
        returning.push( JqUploaderService.convert_to_jq_upload_step(x, @lesson.id, @step.id, "supporting_materials") )
      }
    end

    puts "getting"
    puts returning.inspect

    respond_to do |format|
      format.html {
        render :json => returning.to_json,
               :content_type => 'text/html',
               :layout => false
      }
      format.json {
        render :json => { files: returning }, status: :created, location: @Uploaded
      }
    end
  end
  def step_file_upload
    @lesson = Lesson.find(params[:id])
    # return false unless @lesson.isAuthor?(calling_user.id)
    @step = @lesson.steps.find(params[:step])

    puts file_params.inspect

    files_hash = {}
    files_hash.merge!({supporting_files: file_params[:files]}) if file_params[:attr] == "supporting_files"
    files_hash.merge!({supporting_materials: file_params[:files]}) if file_params[:attr] == "supporting_materials"

    puts files_hash.inspect

    @step.add_file_through_hash(files_hash) # CHECK TO MAKE SURE CALLING USER IS AUTHOR OF
    @step.reload

    returning = []


    if files_hash[:supporting_files].present?
      uploaded_sF = file_params[:files].each{|x|
        @step.find_carrier_wave_with_original_name(x.original_filename, :supporting_files)
      }
      for i in 0..uploaded_sF.count-1
        @step.reload
        x = @step.supporting_files[i]
        returning.push( JqUploaderService.convert_to_jq_upload_step(x, @lesson.id, @step.id, "supporting_files") )
      end
    elsif files_hash[:supporting_materials].present?
      uploaded_of = file_params[:files].each{|x|
        @step.find_carrier_wave_with_original_name(x.original_filename, :supporting_materials)
      }
      puts uploaded_of.count
      for i in 0..uploaded_of.count-1
        @step.reload
        x = @step.supporting_materials[i]
        returning.push( JqUploaderService.convert_to_jq_upload_step(x, @lesson.id, @step.id, "supporting_materials") )
      end
    end

    respond_to do |format|
      format.html {
        render :json => returning.to_json,
               :content_type => 'text/html',
               :layout => false
      }
      format.json {
        render :json => { :files => returning }
      }
    end
  end

  def step_remove_file_upload
    puts "prepping for delete"
    puts params.inspect
    @lesson = Lesson.find(params[:id])
    # return false unless @lesson.isAuthor?(calling_user.id)
    @step = @lesson.steps.find(params[:step])
    status = @step.removeFileWithName(remove_file_params[:attr].to_sym, remove_file_params[:name])
    puts "finished for delete"
    render :json => {status: status}, location: @Uploaded
  end

  private

    def lesson_params
      params.require(:lesson).permit(:name, :topline, :summary, :teacher_notes, :assessment_criteria, :state, :collection_tag, :mastery_level_students, :mastery_level_teachers, other_users_emails: [], learning_objectives: [], further_readings: [], outcome_links: [], associated_places_ids: [], standards: [:name, descriptions: []], grade_range: [:start, :end], subjects: [], fabrication_tools: [], key_concepts: [], key_vocabularies: [], key_formulas: [], skills: [:name, :level], contexts: [], tags: [])
    end

    def step_params
      params.permit(steps: [:id, :name, :summary, :duration, :description, :supporting_images => [], :materials => [:number, :name], :tools => [], :supporting_material => [], :external_links => []]) #TODO - supporting materials vs materials... add materials
    end

    def step_param
      params.require(:step).permit(:id, :summary, :duration, materials: [:number, :name], tools: [], external_links:[])
    end

    def file_params # both lessons and steps
      params.permit(:attr, :assessment_criteria_files => [], :outcome_files => [], :supporting_materials => [], :supporting_files => [], :files => [])
    end

    def remove_file_params
      params.permit(:name, :attr)
    end

    def set_lesson
      # The fetching of the lesson should be shared across methods
    end

    def set_collections
      @collections = CollectionTag.all
    end

    def set_contexts
      @contexts = Context.all
    end

    def set_subjects
      @subjects = Subject.all
    end

end
