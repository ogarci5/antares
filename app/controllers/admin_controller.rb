class AdminController < ApplicationController

  def secret
    if cookies[:secret].present?
      cookies[:secret] = cookies[:secret] == 'true' ? false : true
    else
      cookies[:secret] = true
    end

    redirect_to root_path
  end
end