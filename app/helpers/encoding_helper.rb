module EncodingHelper

  # Encode value using user configuration
  # This method assumes current_user exists 
  #
  # @return [String]
  def to_current_encoding(value)
    encoded_value = nil
    if !value.nil?
      begin
        encoded_value = value.encode(current_user.encoding)
      rescue
        encoded_value = value.force_encoding(current_user.encoding)
      end
    end
    encoded_value
  end


end
