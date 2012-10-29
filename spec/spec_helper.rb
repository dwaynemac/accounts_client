require 'typhoeus'
# == begin app initializer
module Overmind
  HYDRA = ::Typhoeus::Hydra.new
  HOST = "localhost:3007"
  APP_KEY = "secret-key"
end
# == end app initializer

require 'support/typhoeus_mocks'

include TyphoeusMocks

