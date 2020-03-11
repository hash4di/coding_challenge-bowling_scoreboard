class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token #easier API preview

  def create
    render json: {game_id: new_game.id}, status: 200
  end

  def show
    render json: {score: game.score}, status: 200
  end

  def update
    game.throw! params[:knocked_pins].to_i
    render json: {}, status: 200
  end

private

  def new_game
    @new_game ||= Game.create
  end

  def game
    @game ||= Game.find(params[:id].to_i)
  end
end
