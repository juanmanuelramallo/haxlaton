# == Schema Information
#
# Table name: rooms
#
#  id            :bigint           not null, primary key
#  api_key       :string           default("t1OtIU2Xy9xgbp8q8GSMnURaz0JCFrSD"), not null
#  max_players   :integer          default(16), not null
#  name          :string           default(""), not null
#  password      :string           default(""), not null
#  public        :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :bigint           not null
#
# Indexes
#
#  index_rooms_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => players.id)
#
class Room < ApplicationRecord
  BUILD_PATH = Rails.root.join("lib", "haxball_client")

  attribute :api_key, :string, default: -> { SecureRandom.alphanumeric(32) }

  validates :api_key, presence: true, uniqueness: true

  belongs_to :created_by, class_name: "Player", foreign_key: "created_by_id", inverse_of: :created_rooms

  def to_javascript
    @to_javascript ||= [
      "var s=document.createElement('script');s.src='",
      Rails.application.routes.url_helpers.room_url(self, host: ENV.fetch("HOST_NAME"), format: :js),
      "';document.body.appendChild(s)"
    ].join
  end

  def haxball_client
    @haxball_client||= Tempfile.open("server") do |f|
      command = [
        "cd",
        BUILD_PATH,
        "&& OUTFILE_NAME=#{f.path}",
        "BASE_API_URL=#{Rails.application.routes.url_helpers.root_url(host: ENV.fetch("HOST_NAME"))}api",
        "node #{BUILD_PATH}/build.js"].join(" ")
      system(command)
      f.read
    end
  end
end
