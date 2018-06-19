class Admin::SummariesController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  helper_method :sort_column, :sort_oder
  before_action :admin_user?

  layout 'admin'

  def index
    @tasks = Summary.all
             .order(sort_column + ' ' + sort_oder)
             .search(params)
             .page(params[:page]).per(10)

    @tasks_close_to_deadline = @tasks.closing_deadline
    @tasks_deadline_over = @tasks.deadline_over
  end

  def new
    @task = Summary.new
    5.times { @task.attachments.build }
  end

  def create
    @task = Summary.new(tasks_params)
    @task.user_id = @current_user.id
    if @task.save
      connect_label
      flash[:success] = t('activerecord.attributes.flash.create')
      redirect_to admin_root_path
    else
      flash[:warning] = @task.errors.full_messages.each
      render 'admin/summaries/new'
    end
  end

  def show
    @files = Attachment.where(summary_id: @task.id)
  end

  def edit; end

  def destroy
    @task.destroy
    flash[:success] = t('activerecord.attributes.flash.destroy')
    redirect_to admin_root_path
  end

  def update
    if @task.update(tasks_params)
      connect_label
      flash[:success] = t('activerecord.attributes.flash.update')
      redirect_to admin_root_path
    else
      flash[:warning] = @task.errors.full_messages.each
      render 'admin/summaries/edit'
    end
  end

  def calendar
    @date_time = Summary.new
    @date_time = params[:datetime].present? ? Date.parse(params[:datetime]) : Date.current
    year = @date_time.year
    month = @date_time.month
    if year >= 1582
      end_day = if month == 2
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
    month_tasks = Summary.month_task(@date_time, Summary.all)
    day_tasks = Summary.calendar_tasks(@date_time, end_day, month_tasks)
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
    params.require(:summary).permit(:task_name, :time_limit, :contents, :status, :priority, :group_id, attachments_attributes: [:file])
  end

  def set_task
    @task = Summary.find(params[:id])
  end

  def calendar_params
    params[:datetime]
  end

  def sort_oder
    %w[asc desc].include?(params[:oder]) ? params[:oder] : 'desc'
  end

  def sort_column
    Summary.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def connect_label
    label_ids = params[:label_id]
    if label_ids.present?
      label_ids.each do |label_id|
        @task.task_labels.find_or_create_by(label_id: label_id)
      end
    end
  end
end
