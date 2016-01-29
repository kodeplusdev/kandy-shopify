class Kandy
  attr_accessor :domain_access_token, :domain_users
  attr_reader :response, :host, :version, :domain_api_key, :domain_api_secret, :user_access_token, :user_devices

  def initialize(params = {})
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    @host ||= 'https://api.kandy.io'
    @version ||= 'v1.2'

    @resource = RestClient::Resource.new(url)
  end

  def url
    host + '/' + version
  end

  def domain_access_token
    if @domain_access_token.blank?
      begin
        res = @resource['/domains/accesstokens'].get params: {key: domain_api_key, domain_api_secret: domain_api_secret}
        json = JSON.parse res, object_class: OpenStruct
        if json.status == 0
          @domain_access_token = json.result.domain_access_token
        end
      rescue => e
        @response = JSON.parse e.response, object_class: OpenStruct
      end
    end
    @domain_access_token
  end

  def domain_users
    if @domain_users.blank?
      begin
        res = @resource['/domains/users'].get params: {key: domain_access_token}
        json = JSON.parse res, object_class: OpenStruct
        if json.status == 0
          @domain_users = json.result.users
        end
      rescue => e
        @response = JSON.parse e.response, object_class: OpenStruct
      end
    end
    @domain_users
  end

  def user_access_token(params)
    if @user_access_token.blank?
      begin
        res = @resource['/domains/users/accesstokens'].get params: {key: domain_api_key, user_id: params[:username], user_password: params[:password]}
        json = JSON.parse res, object_class: OpenStruct
        if json.status == 0
          @user_access_token = json.result.user_access_token
        end
      rescue => e
        @response = JSON.parse e.response, object_class: OpenStruct
      end
    end
    @user_access_token
  end

  def send_sms(params)
    if params[:user_access_token].blank?
      params[:user_access_token] = user_access_token(params)
      params[:device_id] = user_devices(params)[0].id
    end
    begin
      res = @resource["/devices/smss?key=#{params[:user_access_token]}&device_id=#{params[:device_id]}"].post message: {destination: params[:destination], source: params[:source], message: {text: params[:text]}}
      return res.code
    rescue => e
      @response = JSON.parse e.response, object_class: OpenStruct
    end
  end

  def user_devices(params)
    if @user_devices.blank?
      begin
        params[:user_access_token] = user_access_token(params) if params[:user_access_token].blank?

        res = @resource['/users/devices'].get params: {key: params[:user_access_token]}
        json = JSON.parse res, object_class: OpenStruct
        if json.status == 0
          @user_devices = json.result.devices
        end
      rescue => e
        @response = JSON.parse e.response, object_class: OpenStruct
      end
    end
    @user_devices
  end

end