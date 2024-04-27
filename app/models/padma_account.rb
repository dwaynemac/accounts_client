# wrapper for PADMA-Accounts Account API interaction
# Configuration for LogicalModel on /config/initializers/logical_model.rb
class PadmaAccount < LogicalModel
  use_hydra Accounts::HYDRA
  set_resource_host Accounts::HOST
  set_resource_path "/v0/accounts"

  attribute :name
  attribute :vanity_name
  attribute :enabled
  attribute :timezone
  attribute :locale
  attribute :email
  attribute :full_name
  attribute :branded_name
  attribute :nucleo_id
  attribute :migrated_to_padma_on
  attribute :federation_nucleo_id
  attribute :tester_level
  attribute :subscription_name
  attribute :city
  attribute :country
  attribute :coordenates
  attribute :enabled_petals
  attribute :currency
  attribute :local_mailing
  attribute :attendance_enabled

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

  def self.find_by_nucleo_id(nucleo_id, params={})
    res = nil
    params = self.merge_key(params)
    request = Typhoeus::Request.new("#{resource_uri}/by_nucleo_id/#{nucleo_id}", params: params )

    request.on_complete do |response|
      if response.code >= 200 && response.code < 400
        log_ok(response)
        res = self.new.from_json(response.body)
      else
        log_failed(response)
      end
    end

    self.hydra.queue(request)
    self.hydra.run

    res
  end
  
  def self.find_by_vanity_name(vanity_name, params={})
    res = nil
    params = self.merge_key(params)
    request = Typhoeus::Request.new("#{resource_uri}/by_vanity_name/#{vanity_name}", params: params )

    request.on_complete do |response|
      if response.code >= 200 && response.code < 400
        log_ok(response)
        res = self.new.from_json(response.body)
      else
        log_failed(response)
      end
    end

    self.hydra.queue(request)
    self.hydra.run

    res
  end
  
  def self.find_with_rails_cache(account_name,options={})
    pa = Rails.cache.read([account_name,"padma_account"])
    if pa.nil? || options[:refresh]
      pa = find(account_name)
      if pa
        Rails.cache.write([account_name,"padma_account"], pa, :expires_in => (options[:expires_in] || 5.minutes))  
      end
    end
    pa
  end

  private

  # Accounts-ws uses account name of identification
  def id
    name
  end
end
