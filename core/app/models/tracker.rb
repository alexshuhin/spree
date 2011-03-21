class Tracker < ActiveRecord::Base
  def self.current
    Tracker.where('active = ? and environment = ?', true, ENV['RAILS_ENV']).first
  end
end
