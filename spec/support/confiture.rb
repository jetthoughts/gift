require 'confiture'
module Confiture::Configuration::ClassExtension
  def data
    @@data
  end

  def data=(data)
    @@data = data
  end
end
