class DashboardController < ApplicationController
  def index
    @todays_tasks = Task.today.not_completed
    @this_weeks_tasks = Task.this_week
    @slack_messages = Karen::Slack::Message.today
  end

  def anime
    if params[:search].present?
      @animes = Anime.search_by_name(params[:search])
    else
      @animes = Anime.all
    end
  end

  def set_anime_base
    Anime.link = params[:link]
    redirect_to anime_path
  end
end
