# == Schema Information
#
# Table name: lesson_tags
#
#  id            :integer          not null, primary key
#  taggable_id   :uuid             not null
#  taggable_type :string           not null
#  lesson_id     :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class LessonTag < ApplicationRecord

  belongs_to :taggable, polymorphic: true

  validates :taggable_id, presence: true
  validates :taggable_type, presence: true
  validates :lesson_id, presence: true

  validates_uniqueness_of :taggable_id, :scope => [:taggable_type, :lesson_id]

end
