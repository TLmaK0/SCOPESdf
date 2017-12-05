# == Schema Information
#
# Table name: steps
#
#  id                    :uuid             not null, primary key
#  lesson_id             :uuid             not null
#  summary               :string           not null
#  duration              :integer          default(0), not null
#  description           :string           default(""), not null
#  images                :string           default([]), is an Array
#  materials             :json
#  tools                 :string           is an Array
#  design_files          :string           default([]), is an Array
#  external_links        :string           is an Array
#  step_number           :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  software              :string           default([]), is an Array
#  fabrication_equipment :string           default([]), is an Array
#  name                  :string
#

class Step < ApplicationRecord

  validates :lesson_id, presence: true

  before_create :check_step_number, :if => :new_record?
  def check_step_number
    self.step_number ||= self.lesson.steps.count + 1
  end

  before_save do
    self.software = self.software.reject { |x| x.empty? } if self.software.present?
    self.fabrication_equipment = self.fabrication_equipment.reject { |x| x.empty? } if self.fabrication_equipment.present?
  end


  def lesson
    Lesson.find(self.lesson_id)
  end

  def previous_step
    Step.where(lesson_id: lesson_id, step_number: step_number-1).first
  end

  def next_step
    Step.where(lesson_id: lesson_id, step_number: step_number+1).first
  end

  #~~~~ param helpers
  def setArrayThroughSymbolWithTitle(symbol, array, title)
    command = "#{symbol.to_s}="
    self.send(command, { title => array })
  end


  mount_uploaders :images, SupportingFileUploader
  mount_uploaders :design_files, SupportingFileUploader
  def set_files(files)
    puts files.inspect
    self.images = files[:images] if files[:images].present?
    self.design_files = files[:design_files] if files[:design_files].present?
    save!
    reload
  end


  # move the following to its own service:
  def self.find_or_create_and_update(step_id, lesson_id, params, calling_user)
    @lesson = Lesson.find(lesson_id)
    return unless @lesson.hasAuthor?(calling_user)
    puts params
    params[:summary] = "" unless params[:summary].present?
    @step = Step.where(id: step_id).first
    unless @step.present?
      @step = Step.new(summary:"")
      @lesson.steps << @step
    end
    params.delete(:id)

    params[:external_links].delete("") if params[:external_links].present?
    params[:external_links].uniq! if params[:external_links].present?


    params[:tools].delete("") if params[:tools].present?
    params[:tools].uniq! if params[:tools].present?

    params[:materials].delete({number:"", name:""}) if params[:materials].present?
    params[:materials].uniq! if params[:materials].present?

    @step.attributes = params
    @step.save!
    @step.reload
    @step
  end

  def reorder(order_number)

  end

  def self.delete_and_update_sibilings(step_id, lesson_id, calling_user)
    @lesson = Lesson.find(lesson_id)
    return false unless @lesson.hasAuthor?(calling_user)
    return unless Step.where(id: step_id).exists?
    Step.find(step_id).delete
    siblings = @lesson.steps.order(:created_at)
    num = 1
    for s in siblings
      s.step_number = num
      s.save!
      num +=1
    end
    true
  end

  def add_file_through_hash(h)
    url = h.each {|k,v|
      file_type = k.to_s
      self.addFiles(v, file_type.to_sym)
    }
    url
  end





  def addFiles(file, sym)
    returnable =""
    # puts file
    case sym
      when :design_files
        puts "design_files saving"
        collection = self.design_files
        collection += file
        self.design_files = collection
        self.save!
        self.reload
        returnable = self.design_files.map {|x| x.url}
      when :supporting_files
        puts "supporting_files saving"
        collection = self.supporting_files
        collection += file
        self.supporting_files = collection
        self.save!
        self.reload
        returnable = self.supporting_files.map {|x| x.url}
    end
    returnable
  end

  def removeFiles(sym)
    returnable = false
    case sym
      when :design_files
        self.remove_design_files!
        self.save!
        returnable = true
      when :supporting_files
        self.remove_supporting_files!
        self.save!
        returnable = true
    end
    returnable
  end

  #~~~~~~~~~~


  def removeFileWithName(sym, name)
    name.gsub!(" ", "_")
    returnable = false
    case sym
      when :design_files
        index = nil
        self.design_files.each_with_index {|x, i|
          if (x.path.split("/").last.include?(name))
            index = i
          end
        }
        # puts index
        remain_files = self.design_files # copy the array
        deleted_file = remain_files.delete_at(index) # delete the target image
        deleted_file.try(:remove!) # delete image from S3
        if remain_files.empty?
          self.removeFiles(:design_files)
        else
          self.design_files = remain_files # re-assign back
        end
        self.design_files_will_change!
        self.save!; self.reload
        returnable = true
      when :supporting_files
        index = nil
        self.supporting_files.each_with_index {|x, i|
          if (x.path.split("/").last.include?(name))
            index = i
          end
        }
        remain_files = self.supporting_files # copy the array
        deleted_file = remain_files.delete_at(index) # delete the target image
        deleted_file.try(:remove!) # delete image from S3
        if remain_files.empty?
          self.removeFiles(:supporting_files)
        else
          self.supporting_files = remain_files # re-assign back
        end
        self.supporting_files_will_change!
        self.save!; self.reload
        returnable = true
    end
    returnable
  end

  def files_destroy_all
    removeFiles(:design_files)
    removeFiles(:images)
  end

  def find_carrier_wave_with_original_name(og_name, sym)
    og_name.gsub!(" ", "_")
    self.reload
    case sym
      when :supporting_files
        indexes = []
        self.supporting_files.each_with_index {|x, i|
          if x.path.split("/").last.include?(og_name)
            indexes.append(i)
          end
        }
        indexes
      when :design_files
        indexes = []
        self.design_files.each_with_index {|x, i|
          if x.path.split("/").last.include?(og_name)
            indexes.append(i)
          end
        }
        indexes
    end
  end

end
