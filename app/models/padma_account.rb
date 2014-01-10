# wrapper for PADMA-Accounts Account API interaction
# Configuration for LogicalModel on /config/initializers/logical_model.rb
class PadmaAccount < LogicalModel
  self.hydra = Accounts::HYDRA

  self.resource_path = "/v0/accounts"
  self.attribute_keys = [:id, :name, :enabled, :timezone, :email, :full_name, :nucleo_id]
  self.use_api_key = true
  self.api_key_name = "token"
  self.api_key = Accounts::API_KEY
  self.host  = Accounts::HOST

  TIMEOUT = 5500 # milisecons
  PER_PAGE = 9999

  def enabled?
    self.enabled
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

end
