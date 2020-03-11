require 'rails_helper'

RSpec.describe Game, type: :model do
  it "should have score and frames" do
    expect(Game.new.score).to eq 0
    expect(Game.new.frames).to eq [[]]
  end
end