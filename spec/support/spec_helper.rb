require 'simplecov'
SimpleCov.start

require 'minitest/spec'
require 'minitest/mock'
require 'minitest/autorun'

begin
  require 'awesome_print'
  module Minitest::Assertions
    def mu_pp(obj)
      obj.awesome_inspect
    end
  end

  # require 'pry-rescue/minitest'
rescue LoadError
end

require 'ruby-duration'