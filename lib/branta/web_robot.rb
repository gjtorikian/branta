module Branta
  def self.robot
    @robot ||= Robotstxt::Parser.new('Branta')
  end
end
