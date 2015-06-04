class DemoiframeworksController < ApplicationController
  # API_KEY = "cba8502e32d84b58ae97cb6661c264ed"
  # PRIVATE_KEY= "79310ec307f14689b200869ebb8e4203"
  # URL = "http://staging.mobilock.in/sso/sessions/new"
  URL = "http://localhost:4000/sso/sessions/new"

  def index
  end

  # def show
  #   render @url
  # end

  def iframe
    api_key = params[:api_key] #"f77877f580064c0b96b30550f4cfce9f"
    private_key = params[:private_key] #"53af36fd07b64ea99f32b0bccb7fbfc9"
    request_url = params[:request_url]
    key = Digest::SHA1.digest(private_key )
    iv = api_key
    json = JSON.generate(
      :uid => "123456",
      :expires_at => (Time.now + 120).iso8601, # Expire two minutes from now
      :name => params[:name],
      # :redirect_to => "http://google.com",
      :email => params[:email])

    # Encrypt JSON string using AES128-CBC
    cipher = OpenSSL::Cipher::Cipher.new("aes-128-cbc")
    cipher.encrypt # specifies the cipher's mode (encryption vs decryption)
    cipher.key = key
    cipher.iv = iv
    encrypted = cipher.update(json) + cipher.final

    # Prepend encrypted data with the IV
    prepended = iv + encrypted
    # Base64 encode the prepended encrypted data
    multipass = Base64.encode64(prepended)

    # Build an HMAC-SHA1 signature using the encoded multipass and your api key
    signature = Base64.encode64(OpenSSL::HMAC.digest('sha1', private_key, multipass))

    # URL escape the final multipass and signature parameters
    encoded_multipass = CGI.escape(multipass)
    encoded_signature = CGI.escape(signature)
  	@url = request_url + "?token=#{encoded_multipass}&signature=#{encoded_signature}"
  end

end