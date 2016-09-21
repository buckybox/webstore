# frozen_string_literal: true

RSpec.describe ApplicationController do
  describe "GET /ping" do
    it "is successful" do
      get ping_path

      expect(response).to have_http_status :ok
    end
  end
end
