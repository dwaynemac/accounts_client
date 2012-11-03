require "rubygems"
require 'bundler/setup'

require 'accounts_client'
require 'typhoeus'

# == begin app initializer
module Accounts
  HYDRA = ::Typhoeus::Hydra.new
  HOST = "localhost:3002"
  API_KEY = "secret-key"
end
# == end app initializer

require "#{File.dirname(__FILE__)}/../app/models/padma_user.rb"
require "#{File.dirname(__FILE__)}/../app/models/padma_account.rb"

require 'support/typhoeus_mocks'

RSpec.configure do |config|
  config.include TyphoeusMocks
end

