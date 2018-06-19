class TaskLabel < ApplicationRecord
  belongs_to :summary
  belongs_to :label
end
