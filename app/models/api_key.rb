class ApiKey < LogicalModel
  use_hydra Accounts::HYDRA
  set_resource_host Accounts::HOST
  set_resource_path "/v0/api_keys"

  attribute :username
  attribute :account_name
  attribute :access

  set_api_key 'token', Accounts::API_KEY

  TIMEOUT = 5500 # milisecons
  PER_PAGE = 9999

  def json_root
    'api_key'
  end
end
