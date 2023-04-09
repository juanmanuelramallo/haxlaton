require "rails_helper"

RSpec.describe API::RoomsController, type: :request do
  describe "PUT /api/room" do
    let(:room) { create(:room, haxball_room_url: nil) }
    let(:headers) { { "Authorization" => "Bearer #{room.token}" } }
    let(:notification_mock) { instance_double(RoomNotification) }

    subject { put api_room_path(room), params: { room: { haxball_room_url: "https://haxball.com/something" } }, headers: headers }

    before do
      allow(RoomNotification).to receive(:with).and_return(notification_mock)
      allow(notification_mock).to receive(:deliver)
    end

    it "updates the room" do
      expect { subject }.to change { room.reload.haxball_room_url }.from(nil).to("https://haxball.com/something")
    end
  end
end
