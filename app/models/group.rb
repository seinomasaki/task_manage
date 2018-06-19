class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  accepts_nested_attributes_for :group_users

  validates :name, uniqueness: true

  scope :relate_to_myself, ->(user) do
    if user.groups.present?
      where('id IN (?)', user.groups.ids)
    else
      []
    end
  end
end
