require 'rails_helper'
GAME_ERROR = "Game is finished! You can't throw anymore."
CHEATING_ERROR = "Cheater! You can't hit more pins than remaining."

RSpec.describe Game, type: :model do
  let(:game) { Game.new }

  it "should have score and frames" do
    expect(game.score).to eq 0
    expect(game.frames).to eq []
  end


  context "knocking only available pins" do
    context "on a normal frame" do
      it "should knock only available number of pins" do
        expect { game.throw! 11 }.to raise_error CHEATING_ERROR
        expect { game.throw! -1 }.to raise_error CHEATING_ERROR
      end

      it "should knock only available number of pins after a throw" do
        game.throw! 7
        expect { game.throw! 4 }.to raise_error CHEATING_ERROR
      end
    end
  end

  context "with one frame" do
    it "should show correct summed score from two throws" do
      game.throw!(4)
      expect(game.score).to eq 4
      game.throw!(3)
      expect(game.score).to eq 7

      expect(game.frames).to eq [[4,3]]
    end
  end

  context "with multiple frames" do
    it "should show correct summed score from four throws" do
      game.throw! 4
      expect(game.score).to eq 4
      game.throw! 3

      expect(game.score).to eq 7
      expect(game.frames).to eq [[4,3]]

      game.throw! 6
      expect(game.score).to eq 13
      game.throw! 3
        
      expect(game.score).to eq 16
      expect(game.frames).to eq [[4,3], [6,3]]
    end

    context "with a strike" do
      it "should have correct score with a strike at first frame" do
        game.throw! 10
        expect(game.score).to eq 10

        game.throw! 4
        game.throw! 4
        expect(game.score).to eq 26
        expect(game.frames).to eq [[10, 4, 4], [4,4]]
      end
    end

    context "with a spare" do
      it "should have correct score with a spare at first frame" do
        game.throw! 3
        game.throw! 7
        expect(game.score).to eq 10

        game.throw! 4
        game.throw! 4
        expect(game.score).to eq 22
        expect(game.frames).to eq [[3, 7, 4], [4,4]]
      end
    end
  end

  context "with all frames" do
    before :each do
      9.times do
        game.throw! 3
        game.throw! 6
      end
    end

    it "should not allow more throws after 10 frames" do
      game.throw! 3
      game.throw! 6
      expect(game.score).to eq 90
      expect(game.frames).to eq [[3,6]]*10
      expect(game.game_finished?).to eq true
      expect { game.throw! 3 }.to raise_error(GAME_ERROR)
    end

    it "should handle strike in last frame" do
      game.throw! 10
      expect(game.score).to eq 91
      expect(game.game_finished?).to eq false

      expect { game.throw! 2 }.not_to raise_error
      expect(game.score).to eq 93
      expect(game.game_finished?).to eq false

      expect { game.throw! 5 }.not_to raise_error
      expect(game.score).to eq 98
      expect(game.game_finished?).to eq true
      expect { game.throw! 4 }.to raise_error(GAME_ERROR)
    end

    it "should handle spare in last frame" do
      game.throw! 4
      game.throw! 6
      expect(game.score).to eq 91
      expect(game.game_finished?).to eq false

      expect { game.throw! 7 }.not_to raise_error
      expect(game.score).to eq 98
      expect(game.game_finished?).to eq true
      expect { game.throw! 1 }.to raise_error(GAME_ERROR)
    end
  end

end