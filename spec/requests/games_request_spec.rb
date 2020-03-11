require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "POST /games" do
    it "should create a game" do
      post games_path
      expect(response).to have_http_status(200)
      expect(JSON.parse response.body).to include("game_id")
    end
  end

  describe "GET /games/:id" do
    it "should show the score" do
      new_game = Game.create
      get game_path(new_game.id.to_s)
      expect(response).to have_http_status(200)
      expect(JSON.parse response.body).to eq({"score" => 0})
    end
  end

  describe "PUT /games/:id" do
    it "should update score" do
      new_game = Game.create
      put game_path(new_game.id.to_s, "knocked_pins": "5")
      expect(response).to have_http_status(200)
      expect(Game.find(new_game.id).score).to eq 5
    end
  end

end
