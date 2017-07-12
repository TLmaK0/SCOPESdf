# == Schema Information
#
# Table name: lessons
#
#  id                        :uuid             not null, primary key
#  name                      :string           default(""), not null
#  topline                   :string           default(""), not null
#  summary                   :string           default(""), not null
#  learning_objectives       :string           is an Array
#  description               :string           default(""), not null
#  assessment_criteria       :string           default(""), not null
#  assessment_criteria_files :json
#  further_readings          :string           is an Array
#  standards                 :json
#  outcome_files             :json
#  original_lesson           :uuid
#  state                     :integer          default("draft"), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Lesson < ApplicationRecord
  enum state: [:hidden, :draft, :visible]


  # TODO - validate publishing only when all content is set

  # TODO - api view sections for content loading

  # TODO - top right buttons..
  # TODO - activity feed == history of lesson_tags

  # TODO - assessment criteria - input field and file format... ( assessment_criteria_docs :: JSON )


  #   validates :author_exists
  def author_exists         # TODO - validate existence of user from lesson_tags
    # not saved yet... so checking against query doesn't work *
  end
  #   validates :organization_exists
  def organization_exists   # TODO - validate existence of organization from lesson_tags
    # not saved yet... so checking against query doesn't work *
  end



  has_many :steps
  has_many :lesson_tags, dependent: :destroy

  # TODO - search for filter on lesson_tags


  def addAuthor(user_uuid)
    u = User.find(user_uuid)
    self.lesson_tags << LessonTag.new(taggable: u)
  end
  def getAuthors_id
    self.lesson_tags.where(taggable_type: "User").map{|x| y = x.taggable; y.id}
  end
  def authors
    self.lesson_tags.where(taggable_type: "User").map{|x| y = x.taggable; y}
  end
  def removeAuthor(user_uuid)
    self.lesson_tags.where(taggable_type: "User", taggable_id: user_uuid).destroy_all
  end
  def hasAuthor?(u_obj)
    self.lesson_tags.where(taggable_type: "User", taggable_id: u_obj.id).map{|x| y = x.taggable; y if u_obj.id == y.id }.compact.count > 0 ? true : false
  end


  def addOrg(organization_uuid)
    x = Organization.find(organization_uuid)
    self.lesson_tags << LessonTag.new(taggable: x)
  end
  def getOrgs_id
    self.lesson_tags.where(taggable_type: "Organization").map{|x| y = x.taggable; y.id}
  end
  def getOrgs
    self.lesson_tags.where(taggable_type: "Organization").map{|x| y = x.taggable; y}
  end
  def removeOrg(organization_uuid)
    self.lesson_tags.where(taggable_type: "Organization", taggable_id: organization_uuid).destroy_all
  end



  def setTeachingRange(start_range, end_range)
    self.lesson_tags.where(taggable_type: "TeachingRange").map{|x| x.destroy} #sanitize
    TeachingRange.setRangesForLesson(self.id, start_range, end_range)
  end
  def getTeachingRange
    range = self.lesson_tags.where(taggable_type: "TeachingRange").first
    {range_start: range.taggable.range_start, range_end: range.taggable.range_end} if range.present? && range.taggable.present?
  end
  def removeTeachingRange
    self.lesson_tags.where(taggable_type: "TeachingRange").destroy_all
  end



  def setSubjects(string_array)
    string_array.map{ |n|
      s = Subject.find_or_create_by(name: n.downcase)
      self.lesson_tags << LessonTag.new(taggable: s)
    }
  end
  def getSubjects
    self.lesson_tags.where(taggable_type: "Subject").map{|x| y = x.taggable; y.name}
  end
  def removeSubject(string)
    self.lesson_tags.where(taggable_type: "Subject").map{ |x|y = x.taggable; x.destroy if string.downcase == y.name}
  end
  def removeSubjects
    self.lesson_tags.where(taggable_type: "Subject").destroy_all
  end


  def setDifficultyLevel(obj_hash)
    student = DifficultyLevel.find_or_create_by(metric: 0, level: obj_hash[:student].to_i)
    educator = DifficultyLevel.find_or_create_by(metric: 1, level: obj_hash[:educator].to_i)
    self.lesson_tags << LessonTag.new(taggable: student)
    self.lesson_tags << LessonTag.new(taggable: educator)
  end
  def getDifficultyLevel
    self.lesson_tags.where(taggable_type: "DifficultyLevel").map{|x| y = x.taggable; { metric: y.metric, level: y.level} }
  end
  def removeDifficultyLevels
    self.lesson_tags.where(taggable_type: "DifficultyLevel").destroy_all
  end



  def setSkillsLevels(hash_array) # [{name, level}]
    hash_array.map{ |h|
      skill = Skill.find_or_create_by(name: h[:name])
      skill.skill_tags << SkillTag.new(taggable: self, level: h[:level])
    }
  end
  def getSkillsLevels
    SkillTag.where(taggable_type: "Lesson", taggable_id: self.id).map{|x| y = x.skill; {name: y.name, level: x.level}}
  end
  def changeSkillLevel(name, skill_level)
    SkillTag.where(taggable_type: "Lesson", taggable_id: self.id).map{|x|
      if name == x.skill.name
        x.level = skill_level
        x.save!
      end
    }
  end
  def removeSkill(string)
    skill = Skill.where(name: string.downcase).first
    skill.skill_tags.where(taggable_type: "Lesson", taggable_id: self.id).map{ |x|
      x.destroy if string.downcase == x.skill.name
    } if skill.present?
  end
  def removeSkills
    SkillTag.where(taggable_type: "Lesson", taggable_id: self.id).destroy_all
  end


  def setContext(string_array)
    string_array.map{ |n|
      c = Context.find_or_create_by(name: n.downcase)
      self.lesson_tags << LessonTag.new(taggable: c)
    }
  end
  def getContext
    self.lesson_tags.where(taggable_type: "Context").map{|x| y = x.taggable; y.name}
  end
  def removeContext
    self.lesson_tags.where(taggable_type: "Context").destroy_all
  end


  def setOtherInterests(string_array)
    string_array.map{ |n|
      oi = OtherInterest.find_or_create_by(name: n.downcase)
      self.lesson_tags << LessonTag.new(taggable: oi)
    }
  end
  def getOtherInterests
    self.lesson_tags.where(taggable_type: "OtherInterest").map{|x| y = x.taggable; y.name}
  end
  def removeOtherInterest
    self.lesson_tags.where(taggable_type: "OtherInterest").destroy_all
  end


  def setCollectionTag(string)
    ct = CollectionTag.find_or_create_by(name: string.downcase)
    self.lesson_tags << LessonTag.new(taggable: ct)
  end
  def getCollectionTags
    self.lesson_tags.where(taggable_type: "CollectionTag").map{|x| y = x.taggable; y.name}
  end
  def removeCollectionTags
    self.lesson_tags.where(taggable_type: "CollectionTag").destroy_all
  end




  # Likes
  def setLike(user_uuid)
    u = User.find(user_uuid)
    Like.new(user_id: u.id, lesson_id: self.id).save
  end
  def likes
    Like.where(lesson_id: self.id)
  end
  def getLikes_id
    getLikes_obj.map{|x| x.user_id}
  end
  def getLikes_users
    User.where(id: getLikes_id)
  end
  def removeLike(user_uuid)
    u = User.find(user_uuid)
    Like.where(user_id: u.id, lesson_id: self.id).destroy_all
  end


  mount_uploaders :assessment_criteria_files, SupportingFileUploader
  mount_uploaders :outcome_files, SupportingFileUploader


  def addFiles(file, sym)
    returnable =""
    puts file
    case sym
      when :assessment_criteria
        self.assessment_criteria_files = file
        returnable = self.assessment_criteria_files.map{|x| x.url}
        self.save!
      when :outcome
        self.outcome_files = file
        returnable = self.outcome_files.map{|x| x.url}
        self.save!
    end
    returnable
  end
  def removeFiles(sym)
    returnable = false
    case sym
      when :assessment_criteria
        self.remove_assessment_criteria_files!
        self.save!
        returnable = true
      when :outcome
        self.remove_outcome_files!
        self.save!
        returnable = true
    end
    returnable
  end


  # todo - make search ( for visible only )

  # todo - add accessors to all of the children



  # sole viewing data --

  def further_readings_data
    self.further_readings.map{ |x|
      begin
        lt = LinkThumbnailer.generate(x)
        image = VideoThumb::get(x)
        image ||= lt.images.first.src.to_s
        { url: x, title: lt.title, description: lt.description, thumnail: image }
      rescue LinkThumbnailer::Exceptions => e
        { url: x }
      end
    }
  end

  def totalDuration
    sum = 0
    self.steps.map{|x| sum += x.duration}
    sum
  end

  def standards_array
    self.standards["standards"]
  end


end