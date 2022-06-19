class PlayersController < ApplicationController
  def index
    @players = Player.all
      .includes(match_players: [:match, :player_stat])
      .where(match_players: { created_at: from_date..to_date })
      .order("match_players.created_at": :desc)

    if player_ids_to_filter.present?
      @players = @players.where(id: player_ids_to_filter)
    end

    @players_table = @players.map do |player|
      total_games = player.match_players.size
      total_wins = player.match_players.select { |mp| mp.match.winner_team_id == mp.team_id }.size
      total_losses = total_games - total_wins
      victory_rate = (total_wins.to_f / total_games.to_f * 100).round(2)
      player_stats = player.match_players.map(&:player_stat).compact
      total_goals = player_stats.map(&:goals).sum
      total_assists = player_stats.map(&:assists).sum
      total_own_goals = player_stats.map(&:own_goals).sum
      played_secs = player.match_players.map(&:match).map(&:duration_secs).compact.sum
      play_time = FormatSeconds.new(played_secs).format
      elo_to_date = player.match_players.first&.elo_change&.current_elo

      {
        "ID" => player.id,
        "Name" => player.name,
        "Elo" =>  player.elo,
        "Elo (#{to_date})" => elo_to_date,
        "Victory rate" =>  victory_rate,
        "Total games" =>  total_games,
        "Total wins" =>  total_wins,
        "Total losses" =>  total_losses,
        "Total goals" =>  total_goals,
        "Total assists" =>  total_assists,
        "Total own goals" =>  total_own_goals,
        "Play time" => play_time,
        "Last played at" =>  player.match_players.first&.created_at,
      }
    end
  end

  def show
    @player = Player.find(params[:id])

    @match_players = @player.match_players
      .where(created_at: from_date..to_date)
      .order(created_at: :desc)
    @won_match_players = @match_players.joins(<<~SQL)
      JOIN matches
        ON matches.id = match_players.match_id
       AND matches.winner_team_id = match_players.team_id
    SQL
    @lost_match_players = @match_players.joins(<<~SQL)
      JOIN matches
        ON matches.id = match_players.match_id
       AND matches.winner_team_id != match_players.team_id
    SQL

    win_count_by_teammate = @match_players.where(id: @won_match_players)
      .joins(match: { match_players: :player })
      .reorder("")
      .group("players.id")
      .count("matches.id")
    loss_count_by_teammate = @match_players.where(id: @lost_match_players)
      .joins(match: { match_players: :player })
      .reorder("")
      .group("players.id")
      .count("matches.id")

    # To test full count:
    #   some_player.match_players
    #     .joins(match: { match_players: :player })
    #     .where(players: { id: [other_player.id] })
    #     .where("matches.winner_team_id IS NOT NULL")
    #     .count
    #
    # This count must match the sum of both wins and loses by teammate

    @teammates = Player.where(id: win_count_by_teammate.keys + loss_count_by_teammate.keys)
      .where.not(id: @player.id)
      .to_h do |player|
        win_count = win_count_by_teammate.fetch(player.id, 0)
        loss_count = loss_count_by_teammate.fetch(player.id, 0)
        total_count = win_count + loss_count
        [
          player,
          {
            win_count: win_count,
            win_percent: (win_count / total_count.to_f * 100).round(2),
            loss_count: loss_count,
            loss_percent: (loss_count / total_count.to_f * 100).round(2),
            total_count: total_count
          }
        ]
      end

    @most_winner = @teammates.max_by { |t,s| s[:win_count] }
    @most_loser = @teammates.max_by { |t,s| s[:loss_count] }
    @best_teammate = @teammates.max_by { |t,s| s[:win_percent] }
    @worst_teammate = @teammates.max_by { |t,s| s[:loss_percent] }

    @win_percent = (@won_match_players.count.to_f / @match_players.count.to_f * 100).round(2)
  end

  ###
  #
  # Chart data endpoints
  # These are used by chartkick to generate charts asynchronously
  #
  ###
  def elos_by_date
    players = Player.all
      .includes(:elo_changes)
      .where(elo_changes: { created_at: from_date.beginning_of_day..to_date.end_of_day })

    if player_ids_to_filter.present?
      players = players.where(id: player_ids_to_filter)
    end

    data = players.map do |player|
      # Fetch latest elo for a player on a given date
      last_elos_by_date = player.elo_changes.group_by { |ec| ec.created_at.to_date }.map do |date, elos|
        [date, elos.sort_by(&:created_at).last.current_elo]
      end.to_h

      # Fill missing dates with the previous elo the player had. Empty if no elo changes.
      # This is to prevent the chart from showing a gap between the first and the next date a player had a match.
      (from_date..to_date).each do |date|
        last_elos_by_date[date] ||= last_elos_by_date[date - 1.day]
      end

      {
        name: player.name,
        data: last_elos_by_date
      }
    end

    render json: data
  end

  def from_date
    @from_date ||= Date.parse(params[:from_date] || 3.months.ago.to_s)
  end
  helper_method :from_date

  def to_date
    @to_date ||= Date.parse(params[:to_date] || Date.today.to_s)
  end
  helper_method :to_date

  def player_ids_to_filter
    @player_ids_to_filter ||= params[:players]&.reject(&:blank?)
  end
end
