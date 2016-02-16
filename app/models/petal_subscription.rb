class PetalSubscription < LogicalModel

  use_hydra Accounts::HYDRA
  set_resource_host Accounts::HOST
  set_resource_path "/v0/petal_subscriptions"

  attribute :id
  attribute :account_name
  attribute :petal_name

  set_api_key 'token', Accounts::API_KEY

  TIMEOUT = 5500 # milisecons
  PER_PAGE = 9999
end
