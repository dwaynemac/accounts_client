class PadmaUser < LogicalModel
  self.hydra = Accounts::HYDRA
  self.use_ssl = (defined?(Rails)? Rails.env=="production" : ENV['RACK_ENV']=='production')

  self.resource_path = "/v0/users"
  self.attribute_keys = [:username,
                         :drc_login,
                         :email,
                         :locale,
                         :accounts,
                         :current_account_name,
                         :roles,
                         :verbose_help ] # drc_login is OBSOLETE. remove.
  self.use_api_key = true
  self.api_key_name = "token"
  self.api_key = Accounts::API_KEY
  self.host  = Accounts::HOST

  TIMEOUT = 5500 # milisecons
  PER_PAGE = 9999

  # LogicalModel expects an id to create resource_uri
  def id
    self.username
  end

  # @return [PadmaAccount]
  def current_account
    unless cached_current_account
      if self.current_account_name
        self.cached_current_account= PadmaAccount.find(self.current_account_name)
      end
    end
    cached_current_account
  end
  attr_accessor :cached_current_account


  # Returns my accounts as Padma::Account objects
  # @return [Array <PadmaAccount>]
  def padma_accounts
    self.accounts.map{|a|PadmaAccount.new(a)}
  end

  # Returns me enabled accounts as Padma::Account objects
  # @return [Array <PadmaAccount>] enabled accounts
  def enabled_accounts
    return [] if self.accounts.nil?
    self.accounts.reject{|a|!a['enabled']}.map{|a|PadmaAccount.new(a)}
  end

  def verbose_help?
    !!self.verbose_help
  end
end
