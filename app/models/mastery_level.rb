# == Schema Information
#
# Table name: mastery_levels
#
#  id     :uuid             not null, primary key
#  level  :integer          default("easy"), not null
#  metric :integer          default("students"), not null
#

class MasteryLevel < ApplicationRecord
  has_many :lesson_tags, as: :taggable

  # NOVICE INTERMEDIATE ADVANCED

  enum level: [ :easy, :medium, :hard ]
  enum metric: [ :students, :educator ]

  validates_uniqueness_of :metric, :scope => :level

  def self.seed
    for i in 0..2 do
      for j in 0..1 do
        begin
          new(level: i, metric: j).save!
        rescue ActiveRecord::RecordInvalid => e
          next
        end
      end
    end
  end

  def self.form_helper
    {
        students:
            [{
                name: "Easy",
                value: 0
            },
            {
                name: "Medium",
                value: 1
            },
            {
                name: "Hard",
                value: 2
            }],
        teachers:
            [{
                 name: "Easy",
                 value: 0
             },
             {
                 name: "Medium",
                 value: 1
             },
             {
                 name: "Hard",
                 value: 2
             }]
    }
  end


end
