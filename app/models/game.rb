class Game < ApplicationRecord
  include Exceptions
  serialize :frames, Array

  before_save do
    self.score = frames.flatten.sum
    self.frames = [[]] if frames.empty?
  end

  def throw! knocked_pins
    self.transaction do
      self.lock!
      raise(GameFinishedError, "Game is finished! You can't throw anymore.") if game_finished?
      raise(InvalidAvailablePinsError, "Cheater! You can't hit more pins than remaining.") unless knocked_pins.between?(0, available_pins)
      frames.last << knocked_pins
      complete_previous_open_frame_with knocked_pins
      frames << [] if frame_completed?(frames.last) && game_finished?.!
      save!
    end
  end

  def game_finished?
    frames.size==10 && frame_completed?(frames.last)
  end

  private

  def complete_previous_open_frame_with value
    frames.map do |frame|
      next if frame.equal?(frames.last)
      #strike = knocked 10 pins with 1st throw
      frame << value if strike?(frame) && frame.size <= 2
      #spare = knocked 10 pins in two throws
      frame << value if spare?(frame) && frame.size == 2
    end
  end

  def frame_completed? frame
    return ending_frame_completed?(frame) if ending_frame?(frame)
    return true if frame.nil? || frame.size==2 || frame[0]==10
    false
  end

  def ending_frame_completed? frame
    if (strike?(frame) || spare?(frame))
      frame.size==3
    else
      frame.size==2
    end
  end

  def strike? frame
    frame[0] == 10
  end

  def spare? frame
    [frame[0],frame[1]].compact.sum == 10
  end

  def ending_frame? frame
    frames.size==10 && frames.last.equal?(frame)
  end

  def available_pins
    current_frame = frames.last
    current_frame_score = current_frame.to_a.sum
    if ending_frame?(current_frame)
      return (10*2 - current_frame_score) if strike?(current_frame) || spare?(current_frame)
    end
    10 - current_frame_score
  end

end