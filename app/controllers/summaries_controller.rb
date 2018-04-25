class SummariesController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  def index
    @tasks = Summary.all
  end

  def new
    @tasks = Summary.new
  end

  def create
    @tasks = Summary.new(tasks_params)
    if @tasks.save
      flash[:notice] = 'タスクを作成しました。'
      redirect_to @tasks
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def destroy
    @tasks.destroy
    flash[:notice] = 'タスクを削除しました。'
    redirect_to summary_path
  end

  def update
    if @tasks.update(tasks_params)
      flash[:notice] = 'タスクを編集しました。'
      redirect_to @tasks
    else
      render 'edit'
    end
  end


  private

  def tasks_params
    params.require(:summary).permit(:task_name, :label, :time_limit, :contents)
  end

  def set_task
    @tasks = Summary.find(params[:id])
  end

end
