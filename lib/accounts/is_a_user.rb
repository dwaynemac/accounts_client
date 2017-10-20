# This module will include BelongsToUser and BelongsToAccount
# It requires base class to respond to:
# - username
# - account_name
# - account_name=
# - account_name_changed?
module Accounts
  module IsAUser

    def self.included(base)
      base.send(:validate, :has_access_to_current_account)
      base.send(:include, Accounts::BelongsToUser)
      base.send(:include, Accounts::BelongsToAccount)

      base.send(:include, Gravtastic)
      base.send(:gravtastic)

      begin
        unless base.new.respond_to?(:email)
          base.send(:delegate, :email, to: :padma_user, allow_nil: true)
        end
      rescue
        # this is run when booting app, is base model needs DB persistance and this has not yet been provided
        # app will never boot or be able to run migrations. so we rescue exception here.
      end
      base.send(:delegate, :verbose_help?, to: :padma_user, allow_nil: true)
    end

    # @param [Boolean] cache
    # @return [PadmaUser]
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

    # Returns CSV options associated with this user from PADMA ACCOUNTS
    #
    # @return [Hash] 
    def csv_options(override_options={})
      options = CSV_DEFAULTS.clone
      options[:col_sep] = self.padma.try :separator
      options[:encoding] = self.padma.try :encoding

      return options.merge(override_options.to_hash.symbolize_keys!)
    end

    def encoding
      @encoding ||= self.padma.encoding 
    end

    def separator
      @separator ||= self.padma.separator
    end

    private

    # Validates that current_account_name
    # checking that user belongs to such account
    def has_access_to_current_account
      return if self.padma.try(:current_account).nil?

      if self.enabled_accounts.nil?
        # nil means error in connection
        self.errors.add(:current_account_id, I18n.t('user.couldnt_connect_to_check_current_account'))
      else
        unless self.padma.current_account_name.in?(self.enabled_accounts.map{|ea|ea.name})
          self.errors.add(:current_account_id, I18n.t('user.invalid_current_account'))
        end
      end

    end
  end
end
