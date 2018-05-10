class Summary < ApplicationRecord
  validates :task_name, presence: true,
                        length: { maximum: 25 }
  validates :label, presence: true,
                    length: { maximum: 15 }
  validates :time_limit, presence: true
  validates :contents, presence: true,
                       length: { maximum: 100 }
end
