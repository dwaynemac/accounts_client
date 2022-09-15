class ApiKey < LogicalModel
  use_hydra Accounts::HYDRA
  set_resource_host Accounts::HOST
  set_resource_path "/v0/api_keys"

  attribute :username
  attribute :account_name
  attribute :access
  attribute :key

  set_api_key 'token', Accounts::API_KEY

  TIMEOUT = 5500 # milisecons
  PER_PAGE = 9999

  def self.find(id, params={})
    Rails.logger.warn "ApiKey.find is deprecated. Use ApiKey.check instead"
    self.check(id, params)
  end

  def self.check(key, params={})
    res = nil
    params = self.merge_key(params).merge({api_key: key})
    request = Typhoeus::Request.new("#{resource_uri}/check", params: params )

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

  def json_root
    'api_key'
  end
end
