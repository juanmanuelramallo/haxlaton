class ApplicationController < ActionController::Base
  include Pagy::Backend
  include CurrentPlayer
end
