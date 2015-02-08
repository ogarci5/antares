class DashboardController < ApplicationController
  def index
    @tasks = Task.limit(6)
  end

  def anime
    @animes = Anime.all
  end
end
