# == Schema Information
#
# Table name: generic_tags
#
#  id   :uuid             not null, primary key
#  name :string           not null
#

class GenericTag < ApplicationRecord
  has_many :lesson_tags, as: :taggable

  validates_uniqueness_of :name

  before_create :downcase_name, :if => :new_record?

  def downcase_name
    self.name = self.name.downcase
  end

end
