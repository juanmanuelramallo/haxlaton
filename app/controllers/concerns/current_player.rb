module CurrentPlayer
  extend ActiveSupport::Concern

  included do
    helper_method :current_player, :player_signed_in?
  end

  def authenticate_player!
    redirect_to(new_session_path, alert: "Ahí que estar logueado") if current_player_id.blank?
  end

  def current_player
    @current_player ||= Player.find(current_player_id)
  end

  def player_signed_in?
    current_player_id.present?
  end

  private

  def current_player_id
    session[:player_id]
  end
end
