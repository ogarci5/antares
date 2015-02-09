class DashboardController < ApplicationController
  def index
    @tasks = Task.main.limit(6)
  end

  def anime
    @animes = Anime.all
  end
end
