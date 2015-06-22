class DashboardController < ApplicationController

  def index
    @todays_tasks = Task.today.not_completed
    @this_weeks_tasks = Task.this_week
    @slack_channels = Karen::Slack::Channel.all
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

  def japan
    @kanji = Rails.cache.fetch('kanji') { ActiveSupport::JSON.decode(File.read('jlpt_n5_kanji.json'))}
    @full_kanji = Rails.cache.fetch('kanji') { ActiveSupport::JSON.decode(File.read('jlpt_kanji.json'))}
    @vocab = Rails.cache.fetch('vocab') { ActiveSupport::JSON.decode(File.read('jlpt_n5_vocab.json'))}
    @grammar = Rails.cache.fetch('grammar') { ActiveSupport::JSON.decode(File.read('jlpt_n5_grammar.json'))}

  end
end
