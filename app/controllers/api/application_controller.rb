module API
  class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    before_action :authenticate!

    def authenticate!
      authenticate_or_request_with_http_token do |token, options|
        @current_room = Room.find_by(token: token)
      end
    end
  end
end
