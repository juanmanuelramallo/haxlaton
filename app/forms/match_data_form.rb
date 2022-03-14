class MatchDataForm
  def initialize(match_params:, scoreboard_log_params:)
    @match_params = match_params
    @scoreboard_log_params = scoreboard_log_params
  end

  def save
    match.match_players.each do |match_player|
      existing_player = Player.find_by(name: match_player.player.name)

      next unless existing_player.present?

      elo_change = match_player.elo_change
      match_player.player = existing_player
      match_player.elo_change = elo_change
    end

    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless [match.save, scoreboard_log.save].all?
    end
  end

  def data
    match.attributes.merge(match_url: match_url(match))
  end

  def errors
    match.errors.full_messages + scoreboard_log.errors.full_messages
  end

  private

  attr_reader :match_params
  attr_reader :scoreboard_log_params

  def match
    @match ||= Match.new(match_params)
  end

  def scoreboard_log
    @scoreboard_log ||= ScoreboardLog.new(scoreboard_log_params.merge(match: match))
  end

  def match_url(match)
    Rails.application.routes.url_helpers.match_url(match)
  end
end
