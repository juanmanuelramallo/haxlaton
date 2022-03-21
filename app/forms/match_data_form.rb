class MatchDataForm
  def initialize(match_params:)
    @match_params = match_params
  end

  def save
    match.match_players.each do |match_player|
      existing_player = Player.find_by(name: match_player.player.name)

      next unless existing_player.present?

      match_player.player = existing_player
    end

    match.save
  end

  def data
    match.attributes.merge(match_url: match_url(match))
  end

  def errors
    match.errors.full_messages
  end

  private

  attr_reader :match_params

  def match
    @match ||= Match.new(match_params)
  end

  def match_url(match)
    Rails.application.routes.url_helpers.match_url(match)
  end
end
