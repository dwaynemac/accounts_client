require 'logical_model'
if defined?(Rails)
  require 'accounts/railties'
  require 'accounts/is_a_user'
  require 'accounts/belongs_to_account'
  require 'accounts/belongs_to_user'
end
