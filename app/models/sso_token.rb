class SsoToken < LogicalModel
  use_hydra Accounts::HYDRA
  set_resource_host Accounts::HOST
  set_resource_path "/v0/sso_tokens"

  attribute :username
  attribute :account_name

  set_api_key 'token', Accounts::API_KEY

  TIMEOUT = 5500 # milisecons
  PER_PAGE = 9999

  def json_root
    'sso_token'
  end
end
