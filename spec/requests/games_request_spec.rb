require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "POST /games" do
    it "should create an empty game" do
      post games_path
      expect(response).to have_http_status(201)
      expect(JSON.parse response.body).to include("id")
    end
  end

  describe "GET /games/:id" do
    it "should show the empty score" do
      new_game = Game.create
      get game_path(new_game.id.to_s)
      expect(response).to have_http_status(200)
      expect(JSON.parse response.body).to eq({"score" => 0, "frame_number" => 1, "game_finished" => false})
    end
  end

  describe "PUT /games/:id" do
    it "should update score" do
      new_game = Game.create
      put game_path(new_game.id.to_s, "knocked_pins": "5")
      expect(response).to have_http_status(204)
      expect(Game.find(new_game.id).score).to eq 5
      expect(Game.find(new_game.id).frames).to eq [[5]]
    end
  end

  it "should return error message when knocking too many pins" do
    new_game = Game.create
    put game_path(new_game.id.to_s, "knocked_pins": "11")
    expect(response).to have_http_status(422)
    expect(JSON.parse response.body).to eq({"message" => "Cheater! You can't hit more pins than remaining."})
  end


  it "should return error message when throwing after game is over" do
    new_game = Game.create
    10.times do
      put game_path(new_game.id.to_s, "knocked_pins": "4")
      put game_path(new_game.id.to_s, "knocked_pins": "4")
    end

    put game_path(new_game.id.to_s, "knocked_pins": "4")
    expect(response).to have_http_status(422)
    expect(JSON.parse response.body).to eq({"message" => "Game is finished! You can't throw anymore."})
  end

  context " on missing required params" do
    it "should raise error when required param is missing" do
      new_game = Game.create
      expect { put game_path(new_game.id.to_s) }.to raise_error ActionController::ParameterMissing
    end

    it "should raise error when required param is blank" do
      new_game = Game.create
      expect { put game_path(new_game.id.to_s, "knocked_pins" => "") }.to raise_error ActionController::ParameterMissing
    end

    it "should raise error when required param is not a number" do
      new_game = Game.create
      expect { put game_path(new_game.id.to_s, "knocked_pins" => "asdf") }.to raise_error ActionController::ParameterMissing
    end
  end
end