class DashboardController < ApplicationController
  def index
    @todays_tasks = Task.today.not_completed
    @this_weeks_tasks = Task.this_week
    @slack_messages = Karen::Slack::Message.today
  end

  def anime
    @animes = Anime.all
  end
end
