if(defined?(Rails))
  module Accounts

    unless defined? HYDRA
      HYDRA = Typhoeus::Hydra.new
    end

    HOST = case Rails.env
      when "production"
       "padma-accounts.heroku.com"
      when "development"
       "localhost:3001"
      when "test"
       "localhost:3001"
    end
  end
end
