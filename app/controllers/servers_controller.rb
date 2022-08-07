class ServersController < ApplicationController
  BUILD_PATH = Rails.root.join("lib", "haxball_client")

  skip_forgery_protection only: :show

  def show
    Tempfile.open('server') do |f|
      system("cd #{BUILD_PATH} && OUTFILE_NAME=#{f.path} BASE_API_URL=#{root_url}api node #{BUILD_PATH}/build.js")

      render plain: f.read, content_type: "text/javascript"
    end
  end
end
