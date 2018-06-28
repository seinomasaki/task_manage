class LabelsController < ApplicationController
  skip_before_action :admin_user?
  before_action :set_label, only: %i[destroy]


  def index
    @labels = Label.all
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:success] = t('activerecord.attributes.flash.create')
      redirect_to labels_path
    else
      flash[:warning] = @label.errors.full_messages.each
      render 'index'
    end
  end

  def destroy
    @label.destroy
    flash[:success] = t('activerecord.attributes.flash.destroy')
    redirect_to labels_path
  end

  private
  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = Label.find(params[:id])
  end
end