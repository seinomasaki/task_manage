class Summary < ApplicationRecord
  validates :task_name, presence: true,
                        length: { maximum: 25 }
  validates :contents, length: { maximum: 200 }
  validates :status, presence: true
  validates :priority, presence: true

  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
  accepts_nested_attributes_for :task_labels

  belongs_to :user

  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments

  enum status: { '完了': '完了', '着手中': '着手中', '未着手': '未着手' }
  enum priority: { '1': '1', '2': '2', '3': '3', '4': '4' }

  scope :relate_to_myself, ->(user) do
    if user.groups.present?
      where('(user_id = ?) OR (group_id IN (?))', user.id, user.groups.ids)
    else
      where('user_id = ?', user.id)
    end
  end

  def self.group_member(group_id)
    Group.find(group_id)
  end

  def self.search(params)
    tasks = Summary.all
    if params[:task_name].present?
      tasks = tasks.where('task_name like ?', "%#{params[:task_name]}%")
    end
    if params[:label_ids].present?
      tasks = tasks.joins(:task_labels).where('task_labels.label_id IN (?)', params[:label_ids]).distinct
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

  def self.closing_deadline
    now = Date.current
    week_later = now + 1.week
    Summary.where('(time_limit >= ?) and (time_limit <= ?)', now,week_later).where.not(status: '完了')
  end

  def self.deadline_over
    now = Date.current
    Summary.where('time_limit <= ?', now).where.not(status: '完了')
  end

  def self.month_task(datetime,tasks)
    begin_month = datetime.beginning_of_month
    end_month = datetime.end_of_month
    tasks.where('(time_limit >= ?) and (time_limit <= ?)', begin_month,end_month)
  end

  def self.calendar_tasks(datetime, days, tasks)
    day_tasks = []
    1.upto(days) do |day|
      day_tasks << [day, select_day_tasks(tasks, Date.new(datetime.year,datetime.month,day))]
    end
    day_tasks
  end

  def self.select_day_tasks(tasks, day)
    tasks.where('time_limit = ?', day)
  end
end
