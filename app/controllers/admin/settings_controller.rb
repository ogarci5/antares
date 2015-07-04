class Admin::SettingsController < ApplicationController

  def index
    @slack_models = Karen::Slack.models
  end

  def show
    @model = "karen/#{params[:namespace]}/#{params[:type]}".classify.constantize.find(params[:id])
  end

  def update
    @model = "karen/#{params[:namespace]}/#{params[:type]}".classify.constantize.find(params[:id])
    params[@model.model_name].each do |key, value|
      @model.send :"#{key}=", value
    end

    if @model.save
      redirect_to admin_settings_path, flash: { success: 'Model successfully updated.' }
    else
      render :show
    end
  end
end
