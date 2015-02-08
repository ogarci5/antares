class HomeController < ApplicationController
  def index
  end

  def anime
    @animes = Anime.all
  end
end
