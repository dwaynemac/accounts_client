# wrapper for PADMA-Accounts Account API interaction
# Configuration for LogicalModel on /config/initializers/logical_model.rb
class PadmaAccount < LogicalModel
  use_hydra Accounts::HYDRA
  set_resource_host Accounts::HOST
  set_resource_path "/v0/accounts"

  attribute :name
  attribute :enabled
  attribute :timezone
  attribute :locale
  attribute :email
  attribute :full_name
  attribute :nucleo_id
  attribute :migrated_to_padma_on

  set_api_key 'token', Accounts::API_KEY

  TIMEOUT = 5500 # milisecons
  PER_PAGE = 9999

  def enabled?
    self.enabled
  end

  # if true account is padma2
  # if false account is kshema
  # @return [Boolean]
  def migrated?
    !self.migrated_to_padma_on.nil?
  end

  def users
    PadmaUser.paginate(:account_name => self.name)
  end

  def admin
    self.users.select {|u| u.roles.select {|r| r["name"] == "admin"}.first}.first
  end

  def contacts
    PadmaContact.paginate(:account_name => self.name)
  end

  def json_root
    :account
  end

  private

  # Accounts-ws uses account name of identification
  def id
    name
  end
end
