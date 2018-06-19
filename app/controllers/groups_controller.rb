class GroupsController < ApplicationController
  skip_before_action :admin_user?
  before_action :user_logged_in?
  before_action :set_group, only: %i[show edit update destroy]
  helper_method :sort_column, :sort_oder

  def index
    @groups = Group.relate_to_myself(@current_user)
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      connect_user
      flash[:success] = t('activerecord.attributes.flash.create')
      redirect_to groups_path
    else
      flash[:warning] = @task.errors.full_messages
      render 'new'
    end
  end

  def show
    if @current_user.groups.find_by(id: @group.id).nil?
      flash[:error] = I18n.t('activerecord.attributes.flash.unauthorized')
      redirect_to groups_path
    else
      @tasks = Summary.all.where(group_id: params[:id])
    end
  end

  def edit; end

  def update
    if @group.update(group_params)
      connect_user
      flash[:success] = t('activerecord.attributes.flash.update')
      redirect_to groups_path
    else
      flash[:warning] = @task.errors.full_messages
      render 'edit'
    end
  end

  def destroy
    @group.destroy
    flash[:success] = t('activerecord.attributes.flash.destroy')
    redirect_to groups_path
  end


  private
  def group_params
    params.require(:group).permit(:name, :intention)
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def sort_oder
    %w[asc desc].include?(params[:oder]) ? params[:oder] : 'desc'
  end

  def sort_column
    Summary.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def connect_user
    user_ids = params[:user_id]
    user_ids << @current_user.id
    if user_ids.present?
      user_ids.each do |user_id|
        @group.group_users.find_or_create_by(user_id: user_id)
      end
    end
  end
end