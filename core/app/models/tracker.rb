class Tracker < ActiveRecord::Base
  def self.current
    Tracker.where('active = ? and environment = ?', true, Rails.env).first
  end
end
