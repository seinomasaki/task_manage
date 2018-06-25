class SummariesController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  skip_before_action :admin_user?
  helper_method :sort_column, :sort_oder

  def index
    @tasks = Summary.relate_to_myself(@current_user)
                    .order(sort_column + ' ' + sort_oder)
                    .search(params)
                    .page(params[:page]).per(10)

    @tasks_close_to_deadline = Summary.closing_deadline
    @tasks_deadline_over = Summary.deadline_over
  end

  def new
    @task = Summary.new
    5.times { @task.attachments.build }
  end

  def create
    @task = Summary.new(tasks_params)
    @task.user_id = @current_user.id
    if @task.save
      if params[:group_id].present?
        group = group_menber(params[:group_id])
        group.users.each do |user|
          PostMailer.post_email(user, @current_user, @task).deliver
        end
      else
        PostMailer.post_email(@current_user, @current_user, @task).deliver
      end
      connect_related_table
      flash[:success] = t('activerecord.attributes.flash.create')
      redirect_to root_path
    else
      flash[:warning] = @task.errors.full_messages
      render 'new'
    end
  end

  def show
    @files = Attachment.where(summary_id: @task.id)
  end

  def edit
    5.times { @task.attachments.build }
  end

  def destroy
    @task.destroy
    flash[:success] = t('activerecord.attributes.flash.destroy')
    redirect_to root_path
  end

  def update
    if @task.update(tasks_params)
      connect_related_table
      flash[:success] = I18n.t('activerecord.attributes.flash.update')
      redirect_to root_path
    else
      flash[:warning] = @task.errors.full_messages
      render 'edit'
    end
  end

  def calendar
    @date_time = params[:datetime].present? ? Date.parse(params[:datetime]) : Date.current
    month_tasks = Summary.month_task(@date_time, Summary.relate_to_myself(@current_user))
    day_tasks = Summary.calendar_tasks(@date_time, Summary.days_in_a_month(@date_time), month_tasks)
    start_week = @date_time.beginning_of_month.wday
    @day_tasks = Array.new(start_week, Array.new(2)) + day_tasks
    @weekly = if @day_tasks.length % 7 == 0
                @day_tasks.length / 7
              else
                @day_tasks.length / 7 + 1
              end
    @day_tasks = @day_tasks + Array.new(@weekly * 7 - @day_tasks.length) if @day_tasks.length < @weekly * 7
    @tasks = Summary.select_day_tasks(month_tasks, params[:time_limit])

    respond_to do |format|
      format.html
      format.json {}
    end
  end


  private

  def tasks_params
    params.require(:summary).permit(:task_name, :label_ids, :time_limit, :contents, :status, :priority, :group_id, attachments_attributes: [:file])
  end

  def set_task
    @task = Summary.find(params[:id])
  end

  def sort_oder
    %w[asc desc].include?(params[:oder]) ? params[:oder] : 'desc'
  end

  def sort_column
    Summary.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def connect_related_table
    label_ids = params[:label_id]
    if label_ids.present?
      label_ids.each do |label_id|
        @task.task_labels.find_or_create_by(label_id: label_id)
      end
    end
  end
end
