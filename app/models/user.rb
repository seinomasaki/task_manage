class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_secure_password validates: true

  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true

  before_update :admin_edit_restriction

  mount_uploader :profile_image, FileUploader

  has_many :summaries
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  private

  def admin_edit_restriction
    if User.where(admin: true).size <= 1 && !self.admin? && User.all.find(self.id).admin?
      errors.add(:test, '管理者がいなくなってしまします。処理を戻します。')
      throw :abort
    end
  end
end
