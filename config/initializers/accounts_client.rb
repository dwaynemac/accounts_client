if(defined?(Rails))
  module Accounts

    unless defined? HYDRA
      HYDRA = Typhoeus::Hydra.new
    end

    HOST = case Rails.env
      when "production"
       "padma-accounts-staging.herokuapp.com"
      when "development"
       "localhost:3001"
      when "staging"
       "padma-accounts-staging.herokuapp.com"
      when "test"
       "localhost:3001"
    end
  end
end
