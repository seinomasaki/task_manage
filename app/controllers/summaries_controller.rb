# frozen_string_literal: true
class SummariesController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  helper_method :sort_column, :sort_direction

  def index
    @tasks = Summary
             .all.unscoped.order(sort_column + ' ' + sort_direction)
             .search(params)
             .page(params[:page]).per(10)
  end

  def new
    @tasks = Summary.new
  end

  def create
    @tasks = Summary.new(tasks_params)
    if @tasks.save
      flash[:success] = t('activerecord.attributes.flash.create')
      redirect_to @tasks
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def destroy
    @tasks.destroy
    flash[:success] = t('activerecord.attributes.flash.destroy')
    redirect_to summaries_path
  end

  def update
    if @tasks.update(tasks_params)
      flash[:success] = t('activerecord.attributes.flash.update')
      redirect_to @tasks
    else
      render 'edit'
    end
  end


  private
  def tasks_params
    params.require(:summary).permit(:task_name, :label, :time_limit, :contents, :status, :priority)
  end

  def set_task
    @tasks = Summary.find(params[:id])
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'desc'
  end

  def sort_column
    Summary.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
