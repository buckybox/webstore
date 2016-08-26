# frozen_string_literal: true

RSpec.describe MapController do
  describe "GET /" do
    it "is successful" do
      get root_path

      expect(response).to be_success
    end
  end
end
