class Admin::MessagesController < ApplicationController
  def new
  end

  def create
    @message = Karen::Message.new(message_params)

    if @message.deliver
      redirect_to root_path, flash: { success: 'Message has been successfully sent!' }
    else
      flash.now[:error] = 'There has been a issue sending your message.'
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :recipient)
  end
end
