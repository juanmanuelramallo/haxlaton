require "rails_helper"

RSpec.describe ServersController do
  describe "GET /server" do
    subject { get server_path }

    it "returns the source code for the client" do
      subject

      expect(response.headers["Content-Type"]).to eq "text/javascript; charset=utf-8"
    end
  end
end
