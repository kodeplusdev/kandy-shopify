class WebhookService
  request.body.rewind

  # TODO: Remove this line (or make it ENV specific) to disable test mode
  return true if request.headers['HTTP_X_SHOPIFY_TEST'].to_s == "true"

  # Make sure the encrypted header was passed in (manually setup webhooks don't contain the HMAC)
  hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
  return false if hmac_header.blank?

  # In order to verify the authenticity of the request
  # We need to compare the header hmac to one
  # We compute on the fly
  data = request.body.read.to_s

  # Calculate the hmac using our shared secret and the request body
  digest = OpenSSL::Digest::Digest.new('sha256')
  calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHOPIFY_SHARED_SECRET, data)).strip

  unless calculated_hmac == hmac_header
    return false
  end

  # Rewind the request body so that Rails can reprocess it
  request.body.rewind
  return true

  # This method is provided by Shopify on their Wiki
  def self.verify_webhook request


  end

end
