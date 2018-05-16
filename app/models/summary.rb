class Summary < ApplicationRecord
  validates :task_name, presence: true,
                        length: { maximum: 25 }
  validates :label, presence: true,
                    length: { maximum: 20 }
  validates :contents, length: { maximum: 200 }
  validates :status, presence: true
  validates :priority, presence: true

  enum status: { '完了': '完了', '着手中': '着手中', '未着手': '未着手' }
  enum priority: { '1': '1', '2': '2', '3': '3', '4': '4' }

  def self.search(params)
    tasks = Summary.all
    if params[:task_name].present?
      tasks = tasks.where('task_name like ?', "%#{params[:task_name]}%")
    end
    if params[:label].present?
      tasks = tasks.where('label like ?', "%#{params[:label]}%")
    end
    if params[:status].present?
      tasks = tasks.where(status: params[:status])
    end
    if params[:priority].present?
      tasks = tasks.where(priority: params[:priority])
    end
    if params[:contents].present?
      tasks = tasks.where('contents like ?', "%#{params[:contents]}%")
    end
    tasks
  end
end
