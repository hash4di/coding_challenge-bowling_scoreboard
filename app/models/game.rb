class Game < ApplicationRecord
  serialize :frames, Array

  after_initialize do
      self.frames = [[]]
  end

  before_save do
    self.score = frames.flatten.sum
  end

  def throw!(knocked_pins)
    frames.last << knocked_pins
    save!
  end

end