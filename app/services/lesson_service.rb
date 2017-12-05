class LessonService
  class << self

    # Expected Parameters
    # id = optional
    # params = see LessonsController::lesson_params
    # calling_user = user making this request


    def find_or_create_and_update(id, params, calling_user)
      params ||= {}
      # puts params << for testing internally


      prepParams(calling_user, params)
      @lesson = find_or_createHidden(id)
      associateAuthors!
      associatePlaces!
      updateData!
      #~
      updateStandards!
      updateTeachingRange!
      updateSubjects!
      updateDifficultyLevel!
      updateSkills!
      updateContext!
      updateCollectionTag!
      updateTags!
      @lesson
    end
    def prepParams(usr, given)
      # if given
      #   other_users = given.delete(:other_users_emails)
      #   associated_places = given.delete(:associated_places_ids)
      #   standards = given.delete(:standards)
      #   teaching_range = given.delete(:grade_range)
      #   subjects = given.delete(:subjects)
      #   mastery_level = given.delete(:mastery_level)
      #   skills = given.delete(:skills)
      #   context = given.delete(:contexts)
      #   other_interests = given.delete(:tags)
      #   collection = given.delete(:collection_tag)
      # end


      params = {
          lesson: given,
          # places: associated_places,
          # standards: standards,
          # mastery_level: mastery_level,
          # skills: skills
      }

      # puts skills.inspect

      @calling_user = usr
      @other_authors = given.delete(:other_users_emails)
      @places = given.delete(:associated_places_ids)
      @standards = given.delete(:standards)
      @teaching_range = given.delete(:grade_range)
      @subjects = given.delete(:subjects)

      @mastery_level = {student: given.delete(:mastery_level_students), educator: given.delete(:mastery_level_teachers)} if given[:mastery_level_students].present? && given[:mastery_level_teachers].present?

      @skills = given.delete(:skills)
      @context = given.delete(:contexts)
      @collection = given.delete(:collection_tag)
      @generic_tags = given.delete(:tags)

      params = {
          lesson: given,
          # places: associated_places,
          # standards: standards,
          # mastery_level: mastery_level,
          # skills: skills
      }
      @lesson_params = params[:lesson]



    end


    # acceptable types: assessment_criteria
    #file_params : {assessment_criteria_files: [], ...}
    def add_file_by_type_to_id(id, file_params)
      @lesson = Lesson.find(id)
      #check https://github.com/dwilkie/carrierwave_direct

      puts file_params.inspect

      url = file_params.each {|k,v|
        file_type = k.to_s
        file_type.gsub!("_files","")
        @lesson.addFiles(v, file_type.to_sym)
      }
      # puts url

      url
    end
    def remove_file_by_name_type_on_id(id, file, type, calling_user)
      @lesson = Lesson.find(id)
      return false unless @lesson.isAuthor?(calling_user.id)

      true
    end


    private

    def find_or_createHidden(id)
      Lesson.find_or_create_by!(id: id) do |x|
        x.state = 0
      end
    end

    def associateAuthors!
      @lesson.lesson_tags.where(taggable_type: "User").map{|x| x.destroy } # sanitize
      @lesson.addAuthor(@calling_user.id)
      return unless @other_authors.present?
      @other_authors.map{ |x|
      #   #add author or invite user
        u = User.where(email: x).first
        if u.present?
          @lesson.addAuthor(u.id)
        else
          InviteUserService.invite(x) # TODO - see how to handle lesson... NEED TO ASSOCIATE TO LESSON SOMEHOW
        end
      }
      @lesson.save!
      @lesson.reload
    end

    def updateData!
      return unless @lesson_params.present?
      @lesson.state = 1   # draft state

      # cleaning - from form
      @lesson_params[:learning_objectives].delete("") if @lesson_params[:learning_objectives].present?
      @lesson_params[:further_readings].delete("") if @lesson_params[:further_readings].present?

      @lesson.attributes = @lesson_params
      # puts @lesson.inspect
      @lesson.save!
      @lesson.reload
    end

    def associatePlaces!
      return unless @places.present?
      @lesson.lesson_tags.where(taggable_type: "Organization").map{|x| x.destroy } # sanitize
      @places.map{ |x|
        @lesson.addOrg(x)
      }
      @lesson.save!
      @lesson.reload
    end

    def updateStandards!

      # moved to model check Lesson.rb
      # - append
      # - delete
      # - sanitie
      # - override

      # return unless @standards.present?
      # @lesson.standards = {standards: @standards}
      # @lesson.save!
      # @lesson.reload
    end

    def updateTeachingRange!
      return unless @teaching_range.present? && @teaching_range[:start].present? && @teaching_range[:end].present?
      @lesson.removeTeachingRange # sanitize
      @lesson.setTeachingRange(@teaching_range["start"], @teaching_range["end"])
      @lesson.save!
      @lesson.reload
    end

    def updateSubjects!
      return unless @subjects.present?
      @lesson.removeSubjects # sanitize
      @lesson.setSubjects_id(@subjects)
      @lesson.save! 
      @lesson.reload
    end

    def updateDifficultyLevel!
      return unless @mastery_level.present?
      @lesson.removeMasteryLevels # sanitize
      @lesson.setMasteryLevel(@mastery_level)
      @lesson.save!
      @lesson.reload
    end

    def updateSkills!
      return unless @skills.present?
      @lesson.removeSkills # sanitize
      @lesson.setSkillsLevels(@skills)
      @lesson.save!
      @lesson.reload
    end

    def updateContext!
      return unless @context.present?
      @lesson.removeContext # sanitize
      @lesson.setContext_id(@context)
      @lesson.save!
      @lesson.reload
    end

    def updateCollectionTag!
      return unless @collection.present?
      @lesson.removeCollectionTags # sanitize
      @lesson.setCollectionTag(@collection)
      @lesson.save!
      @lesson.reload
    end

    def updateTags!
      return unless @generic_tags.present?
      @lesson.removeTags # sanitize
      @generic_tags = @generic_tags.reject { |x| x.empty? }
      @lesson.setTags(@generic_tags)
      @lesson.save!
      @lesson.reload
    end

  end
end