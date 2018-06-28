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

  def self.search(params)
    tasks = Summary.all
    if params[:task_name].present?
      tasks = tasks.where('task_name like ?', "%#{params[:task_name]}%")
    end
    if params[:label_ids].present?
      tasks = tasks.joins(:task_labels).where('task_labels.label_id IN (?)', params[:label_ids]).distinct
    end
    tasks = tasks.where(status: params[:status]) if params[:status].present?
    if params[:priority].present?
      tasks = tasks.where(priority: params[:priority])
    end
    if params[:contents].present?
      tasks = tasks.where('contents like ?', "%#{params[:contents]}%")
    end
    tasks
  end

  def self.close_deadline
    now = Date.current
    week_later = now + 1.week
    self.where('(time_limit >= ?) and (time_limit <= ?)', now, week_later).where.not(status: '完了')
  end

  def self.deadline_over
    now = Date.current
    self.where('time_limit <= ?', now).where.not(status: '完了')
  end

  def self.month_task(datetime, tasks)
    begin_month = datetime.beginning_of_month
    end_month = datetime.end_of_month
    tasks.where('(time_limit >= ?) and (time_limit <= ?)', begin_month, end_month)
  end

  def self.calendar_tasks(datetime, days, tasks)
    day_tasks = []
    1.upto(days) do |day|
      day_tasks << [day, select_day_tasks(tasks, Date.new(datetime.year, datetime.month, day))]
    end
    day_tasks
  end

  def self.select_day_tasks(tasks, day)
    tasks.where('time_limit = ?', day)
  end

  def self.days_in_a_month(date_time)
    year = date_time.year
    month = date_time.month
    if year >= 1582
      if month == 2
        if year % 4 == 0 && year % 100 != 0 || year % 400 == 0
          29
        else
          28
        end
      elsif month <= 7
        if month.even?
          30
        else
          31
        end
      else
        if month.even?
          31
        else
          30
        end
      end
    end
  end
end
