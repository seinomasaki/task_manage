class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy
  has_many :summaries, through: :task_labels

  validates :name, presence: true,
                   uniqueness: true
end
