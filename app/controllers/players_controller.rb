class PlayersController < ApplicationController
  before_action :authenticate_player!, only: [:edit, :update]

  def index
    @players = Player.all
      .includes(match_players: [:match, :player_stat, :elo_change])
      .where(match_players: { created_at: date_range })
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
      all_elos = player.match_players.map(&:elo_change).map(&:current_elo)
      ath_elo = all_elos.max
      atl_elo = all_elos.min

      {
        "ID" => player.id,
        "Name" => player.name,
        "Elo" =>  player.elo,
        "Elo at #{to_date}" => to_date.today? ? nil : elo_to_date,
        "ATH Elo" => ath_elo,
        "ATL Elo" => atl_elo,
        "Victory rate" =>  victory_rate,
        "Total games" =>  total_games,
        "Total wins" =>  total_wins,
        "Total losses" =>  total_losses,
        "Total goals" =>  total_goals,
        "Total assists" =>  total_assists,
        "Total own goals" =>  total_own_goals,
        "Play time" => play_time,
        "Last played at" =>  player.match_players.first&.created_at,
      }.compact
    end
  end

  def show
    @player = Player.find(params[:id])

    @match_players = @player.match_players
      .where(created_at: date_range)
    @player_stats = @match_players.includes(:player_stat).map(&:player_stat).compact
    @elo_changes = @match_players.includes(:elo_change).map(&:elo_change).compact
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

    win_count_by_teammate = @match_players
      .joins(<<~SQL)
        INNER JOIN "matches" ON "matches"."id" = "match_players"."match_id"
        INNER JOIN "match_players" "match_players_matches" ON "match_players_matches"."match_id" = "matches"."id"
          AND "match_players_matches"."team_id" = "match_players"."team_id"
          AND "match_players_matches"."team_id" = "matches"."winner_team_id"
        INNER JOIN "players" ON "players"."id" = "match_players_matches"."player_id"
      SQL
      .where("match_players.player_id": @player.id)
      .where.not("players.id": @player.id)
      .select("players.id, match_players.id")
      .group("players.id")
      .count("match_players.id")
    loss_count_by_teammate = @match_players
      .joins(<<~SQL)
        INNER JOIN "matches" ON "matches"."id" = "match_players"."match_id"
        INNER JOIN "match_players" "match_players_matches" ON "match_players_matches"."match_id" = "matches"."id"
          AND "match_players_matches"."team_id" = "match_players"."team_id"
          AND "match_players_matches"."team_id" != "matches"."winner_team_id"
        INNER JOIN "players" ON "players"."id" = "match_players_matches"."player_id"
      SQL
      .where("match_players.player_id": @player.id)
      .where.not("players.id": @player.id)
      .select("players.id, match_players.id")
      .group("players.id")
      .count("match_players.id")

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
    @played_time = FormatSeconds.new(@match_players.map(&:match).map(&:duration_secs).sum).format
    @played_matches = @match_players.count
    @goals = @match_players.map(&:player_stat).compact.map(&:goals).sum
    @assists = @match_players.map(&:player_stat).compact.map(&:assists).sum
    @own_goals = @match_players.map(&:player_stat).compact.map(&:own_goals).sum
    @goals_per_match = (@goals.to_f / @played_matches.to_f).round(2)
    @assists_per_match = (@assists.to_f / @played_matches.to_f).round(2)
    @own_goals_per_match = (@own_goals.to_f / @played_matches.to_f).round(2)
    all_elos = @elo_changes.map(&:current_elo)
    @ath_elo = all_elos.max
    @atl_elo = all_elos.min
    mps = @match_players.includes(:match).order("match_players.created_at": :desc)
    @winning_streak = 0
    @lose_streak = 0
    mps.each do |mp|
      if @lose_streak == 0 && mp.match.winner_team_id == mp.team_id
        @winning_streak += 1
      elsif mp.match.winner_team_id != mp.team_id
        @lose_streak += 1
      else
        break
      end
    end
  end

  def edit
    @player = current_player
  end

  def update
    @player = current_player

    if @player.update(update_params)
      redirect_to edit_player_path, notice: "Todo óptimo"
    else
      flash.now.alert = "nope"
      render :edit, status: :unprocessable_entity
    end
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
      .where(elo_changes: { created_at: date_range })

    if player_ids_to_filter.present?
      players = players.where(id: player_ids_to_filter)
    end

    data = players.flat_map do |player|
      # Fetch latest elo for a player on a given date
      last_elos_by_date = player.elo_changes.group_by { |ec| ec.created_at.to_date }.map do |date, elos|
        [date, elos.sort_by(&:created_at).last.current_elo]
      end.to_h

      # Fill missing dates with the previous elo the player had. Empty if no elo changes.
      # This is to prevent the chart from showing a gap between the first and the next date a player had a match.
      (from_date..to_date).each do |date|
        last_elos_by_date[date] ||= last_elos_by_date[date - 1.day]
      end

      result = []

      if params[:all_time_values].present?
        all_elos = player.elo_changes.map(&:current_elo)
        ath_elo = all_elos.max
        atl_elo = all_elos.min
        ath_elo_line = (from_date..to_date).to_h { |date| [date, ath_elo] }
        atl_elo_line = (from_date..to_date).to_h { |date| [date, atl_elo] }

        result << {
          name: "ATH Elo #{player.name}",
          data: ath_elo_line
        }
        result << {
          name: "ATL Elo #{player.name}",
          data: atl_elo_line
        }
      end

      result << {
        name: player.name,
        data: last_elos_by_date
      }
      result
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

  def date_range
    (from_date.beginning_of_day)..(to_date.end_of_day)
  end

  def player_ids_to_filter
    @player_ids_to_filter ||= params[:players]&.reject(&:blank?)
  end

  private

  def update_params
    params.require(:player).permit(:password, :name)
  end
end
