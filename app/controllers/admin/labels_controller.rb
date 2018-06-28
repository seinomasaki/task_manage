class Admin::LabelsController < ApplicationController
  before_action :admin_user?
  before_action :set_label, only: %i[destroy]

  layout 'admin'

  def index
    @labels = Label.all
    @label = Label.new
    @graph_data = TaskLabel.joins(:label).group('labels.name').count
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:success] = t('activerecord.attributes.flash.create')
      redirect_to admin_labels_path
    else
      flash[:warning] = @label.errors.full_messages.each
      @labels = Label.all.page(params[:page]).per(10)
      render 'admin/labels/index'
    end
  end

  def destroy
    @label.destroy
    flash[:success] = t('activerecord.attributes.flash.destroy')
    redirect_to admin_labels_path
  end

  private
  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = Label.find(params[:id])
  end
end