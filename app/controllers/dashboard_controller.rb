class DashboardController < ApplicationController
  def index
    @todays_tasks = Task.today.not_completed
    @slack_messages = Karen::Slack::Message.today
  end

  def anime
    @animes = Anime.all
  end
end
