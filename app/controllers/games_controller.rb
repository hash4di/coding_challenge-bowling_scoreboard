class GamesController < ApplicationController
  include Exceptions
  skip_before_action :verify_authenticity_token #easier API preview

  def index
  end

  def create
    render json: {id: new_game.id}, status: 201
  end

  def show
    game_hash = {
      score: game.score,
      score_by_frame: game.frames,
      frame_number: game.frames.count,
      game_finished: game.game_finished?,
    }
    render json: game_hash, status: 200
  end

  def show
    render json: {score: game.score}, status: 200
  end

  def update
    if game
      game.throw! update_params[:knocked_pins].to_i
      render json: {}, status: 200
    else
      render json: {message: "Game not found."}, status: 404
    end

  rescue GameFinishedError, InvalidAvailablePinsError => e
    render json: {message: e.message}, status: 422
  end

private

  def new_game
    @new_game ||= Game.create
  end

  def game
    @game ||= Game.find(params[:id].to_i)
  end
  
  def update_params
    raise(ActionController::ParameterMissing, "Wrong knocked pins data format.") if params[:knocked_pins].to_s.chars.any? {|c| c=~/[^\d]/}
    params.require(:knocked_pins)
    params.permit(:knocked_pins, :id)
  end
end
