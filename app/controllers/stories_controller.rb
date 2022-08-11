class StoriesController < ApplicationController
  def index
    @template_names = Dir["app/views/stories/*.html.erb"].sort
      .map { |f| File.basename(f, ".html.erb") }
      .reject { |f| f == "index" }
  end

  def show
    template_name = Dir["app/views/stories/#{params[:id]}.html.erb"].first

    if template_name
      render template: "stories/#{File.basename(template_name, ".html.erb")}"
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
