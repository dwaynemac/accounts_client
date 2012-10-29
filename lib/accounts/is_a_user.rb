module Accounts
  module IsAUser

    def self.included(base)
      base.send(:validate, :has_access_to_current_account)
      base.send(:include, Accounts::BelongsToUser)
      base.send(:include, Accounts::BelongsToAccount)
      base.send(:delegate, :email, to: :padma_user)
      base.send(:delegate, :verbose_help?, to: :padma_user)
    end

    def padma(cache=true)
      self.user(force_service_call: !cache)
    end

    # Returns true if this user
    # has enabled padma accounts
    # @return [TrueClass]
    def padma_enabled?
      ea = self.enabled_accounts
      !(ea.nil? || ea.empty?)
    end

    # Returns locale for this user retrieving it from PADMA ACCOUNTS
    # @return [String] locale
    def locale
      self.padma.try :locale
    end

    # Returns enabled accounts associated with this user from PADMA ACCOUNTS
    #
    # @return [Array <PadmaAccount>]
    def enabled_accounts
      self.padma.try(:enabled_accounts)
    end

    private

    # Validates that current_account_name
    # checking that user belongs to such account
    def has_access_to_current_account
      return if self.current_account.nil? || !self.current_account_id_changed?

      if self.enabled_accounts.nil?
        # nil means error in connection
        self.errors.add(:current_account_id, I18n.t('user.couldnt_connect_to_check_current_account'))
      else
        unless self.current_account.name.in?(self.enabled_accounts.map{|ea|ea.name})
          self.errors.add(:current_account_id, I18n.t('user.invalid_current_account'))
        end
      end

    end
  end
end