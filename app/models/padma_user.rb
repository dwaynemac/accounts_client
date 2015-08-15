class PadmaUser < LogicalModel

  include Gravtastic
  gravtastic

  use_hydra Accounts::HYDRA

  set_resource_path "/v0/users"
  set_resource_host Accounts::HOST

  set_api_key 'token', Accounts::API_KEY

  attribute :username
  attribute :drc_login
  attribute :email
  attribute :locale
  attribute :encoding
  attribute :separator
  attribute :date_format
  attribute :accounts
  attribute :current_account_name
  attribute :roles
  attribute :verbose_help
  attribute :fb_uid
  attribute :fb_token

  # LogicalModel expects an id to create resource_uri
  alias_attribute :id, :username

  TIMEOUT = 5500 # milisecons
  PER_PAGE = 9999


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
    return nil if self.accounts.nil?
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

  # Attributes will be sent to server under this key.
  # json_root => { ... attributes }
  def json_root
    :user
  end
end
