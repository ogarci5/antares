class Admin::SettingsController < ApplicationController
  before_action :set_model, only: [:show, :edit, :update]

  def index
    @slack_models = Karen::Slack.models
    @notification_models = Karen::Notification.models
    @runescape_models = Karen::Runescape.models
  end

  def new
    @model = "karen/#{params[:namespace]}/#{params[:type]}".classify.constantize.new
  end

  def create
    @model = "karen/#{params[:namespace]}/#{params[:type]}".classify.constantize.new

    params[@model.model_name].each do |key, value|
      @model.send :"#{key}=", value
    end

    if @model.save
      redirect_to admin_settings_path, flash: { success: 'Model successfully created.' }
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      if params[:info] == 'true'
        format.json { render json: @model.info }
      elsif params[:info_items] == 'true'
        format.json { render json: @model.info_items(params['letter'], params['page']) }
      else
        format.json { render json: @model }
      end
    end
  end

  def edit
  end

  def update
    params[@model.model_name].each do |key, value|
      @model.send :"#{key}=", value
    end

    if @model.save
      redirect_to admin_settings_path, flash: { success: 'Model successfully updated.' }
    else
      render :edit
    end
  end

  def update_messages
    Karen::Slack::Message.update_all
    redirect_to admin_settings_path
  end

  private

  def set_model
    @model = "karen/#{params[:namespace]}/#{params[:type]}".classify.constantize.find(params[:id])
  end
end
