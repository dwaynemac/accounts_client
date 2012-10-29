# this module assumes base class has a username attribute.
#
# Including this module adds Class#user to access PadmaUser stored in memory in Class#padma_user
module Accounts
  module BelongsToUser

    def self.included(base)
      base.send(:validate, :padma_user_setted_correctly)
    end

    attr_accessor :padma_user
    ##
    # Returns associated user.
    #
    # user is stored in instance variable padma_user. This allows for it to be setted in a Mass-Load.
    #
    # @param options [Hash]
    # @option options [TrueClass] decorated          - returns decorated user
    # @option options [TrueClass] force_service_call - forces call to users-ws
    # @return [PadmaUser / PadmaUserDecorator]
    def user(options={})
      if self.padma_user.nil? || options[:force_service_call]
        self.padma_user = PadmaUser.find(username)
      end
      # TODO cache
      ret = padma_user
      if options[:decorated] && padma_user
        ret = PadmaUserDecorator.decorate(padma_user)
      end
      ret
    end

    private

    # If padma_user is setted with a PadmaUser that doesn't match
    # Class#username an exception will be raised
    # @raises 'This is the wrong user!'
    # @raises 'This is not a user!'
    def padma_user_setted_correctly
      return if self.padma_user.nil?
      unless padma_user.is_a?(PadmaUser)
        raise 'This is not a user!'
      end
      if padma_user.username != self.username
        if self.username.nil?
          # if they differ because user_id is nil we set it here
          self.username = self.padma_user.username
        else
          raise 'This is the wrong user!'
        end
      end
    end
  end
end
