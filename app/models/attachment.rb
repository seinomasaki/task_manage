class Attachment < ApplicationRecord
  belongs_to :summary
  mount_uploader :file, FileUploader
end
