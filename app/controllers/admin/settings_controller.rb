class Admin::SettingsController < ApplicationController
  before_action :set_model, only: [:edit, :update]

  def index
    @slack_models = Karen::Slack.models
    @notification_models = Karen::Notification.models
    @runescape_models = Karen::Runescape.models
  end

  def new
    @model = "karen/#{params[:namespace]}/#{params[:type]}".classify.constantize.new
  end

  def create
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
      render :show
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
