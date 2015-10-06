class Kandy
  attr_accessor :host, :version, :api_key, :api_secret, :access_token

  def initialize(params = {})
    self.host = params[:host] || 'https://api.kandy.io'
    self.version = params[:version] || 'v1.2'
    self.api_key = params[:api_key] || ''
    self.api_secret = params[:api_secret] || ''
    self.access_token = params[:access_token] || ''
    @resource = RestClient::Resource.new(url)
    RestClient.log = Logger.new(STDOUT)
  end

  def url
    host + '/' + version
  end

  def get_user_access_token(username, password)
    res = @resource['/domains/users/accesstokens'].get params: {key: api_key, user_id: username, user_password: password}
    json = JSON.parse res.to_s
    json
  end

  def send_sms(params = {})
    res = get_user_devices
    if res['status'] == 0
      device_id = res['result']['devices'][0]['id']
      # key: access_token, device_id: device_id
      res = @resource["/devices/smss?key=#{access_token}&device_id=#{device_id}"].post message: {destination: params[:to], source: params[:from], message: {text: params[:text]}}, params: {demo: 'demo'}
      json = JSON.parse res.to_s
      json
    end
  end

  def get_user_devices
    res = @resource['/users/devices'].get params: {key: access_token}
    json = JSON.parse res.to_s
    json
  end

end