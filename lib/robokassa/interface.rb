require 'cgi'

module Robokassa
  class InvalidSignature < ArgumentError; end

  def self.setup
    yield self
  end
  
  class Interface
    cattr_accessor :config

    @@default_options = {
      :language => "ru"
    }

    @@notification_params_map = {
        'OutSum'         => :amount,
        'InvId'          => :invoice_id,
        'SignatureValue' => :signature,
        'Culture'        => :language
      }

    @@params_map = {
        'MrchLogin'      => :login,
        'OutSum'         => :amount,
        'InvId'          => :invoice_id,
        'Desc'           => :description,
        'Email'          => :email,
        'IncCurrLabel'   => :currency,
        'Culture'        => :language,
        'SignatureValue' => :signature
      }.invert

    @@service_params_map = {
        'MerchantLogin'  => :login,
        'Language'       => :language,
        'IncCurrLabel'   => :currency,
        'OutSum'         => :amount
      }.invert

    
    # Indicate if calling api in test mode
    # === Returns
    # true or false
    def test_mode?
      @options[:test_mode] || false
    end

    def owner
      @options[:owner]
    end

    # Takes options to access Robokassa API
    # 
    # === Example
    #   Robokassa::Interface.new test_mode: true, login: 'demo', password1: '12345', password2: 'qweqwe123'
    #
    def initialize(options)
      @options = @@default_options.merge(options.symbolize_keys)
      @cache   = {}
    end


    # build signature string
    def self.response_signature_string(parsed_params)
      custom_options_fmt = parsed_params[:custom_options].sort.map{|x|"shp#{x[0]}=x[1]]"}.join(":")
      "#{parsed_params[:amount]}:#{parsed_params[:invoice_id]}:#{@options[:password2]}#{custom_options_fmt.blank? ? "" : ":" + custom_options_fmt}"
    end
    
    # calculates signature to check params from Robokassa
    def self.response_signature(parsed_params)
      md5 response_signature_string(parsed_params)
    end
    
    def self.validate_signature(params)
      parsed_params = map_params(params, @@notification_params_map)
      parsed_params[:custom_options] = Hash[params.select do |k,v| k.starts_with?('shp') end.sort.map do|k, v| [k[3, k.size], v] end]
      if response_signature(parsed_params) != parsed_params[:signature].downcase
        raise Robokassa::InvalidSignature
      end
    end
    
    # This method verificates request params recived from robocassa server
    def self.notify(params, controller)
      begin
        validate_signature(params)
        parsed_params = map_params(params, @@notification_params_map)
        self.class.notify_implementation(
          parsed_params[:invoice_id], 
          parsed_params[:amount], 
          parsed_params[:custom_options], 
          controller)
        "OK#{parsed_params[:invoice_id]}"
      rescue Robokassa::InvalidSignature
        "signature_error"
      end
    end
    
    # Handler for success api callback
    # this method calls from RobokassaController
    # It requires Robokassa::Interface.success_implementation to be inmplemented by user
    def self.success(params, controller)
      validate_signature(params)
      parsed_params = map_params(params, @@notification_params_map)
      success_implementation(
        parsed_params[:invoice_id], 
        parsed_params[:amount], 
        parsed_params[:language], 
        parsed_params[:custom_options], 
        controller)
    end

    # Fail callback requiest handler
    # It requires Robokassa::Interface.fail_implementation to be inmplemented by user
    def self.fail(params, controller)
      parsed_params = map_params(params, @@notification_params_map)
      fail_implementation(
        parsed_params[:invoice_id], 
        parsed_params[:amount], 
        parsed_params[:language], 
        parsed_params[:custom_options], 
        controller)
    end


    # Generates url for payment page
    #
    # === Example
    # <%= link_to "Pay with Robokassa", interface.init_payment_url(order.id, order.amount, "Order #{order.id}", '', 'ru', order.user.email) %>
    #
    def init_payment_url(invoice_id, amount, description, currency='', language='ru', email='', custom_options={})
      url_options = init_payment_options(invoice_id, amount, description, custom_options, currency, language, email)
      "#{init_payment_base_url}?" + url_options.map do |k, v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}" end.join('&')
    end

    # make hash of options for init_payment_url
    def init_payment_options(invoice_id, amount, description, custom_options = {}, currency='', language='ru', email='')
      options = {
        :login       => @options[:login],
        :amount      => amount.to_s,
        :invoice_id  => invoice_id,
        :description => description[0, 100],
        :signature   => init_payment_signature(invoice_id, amount, description, custom_options),
        :currency    => currency,
        :email       => email,
        :language    => language
      }.merge(Hash[custom_options.sort.map{|x| ["shp#{x[0]}", x[1]]}])
      map_params(options, @@params_map)
    end

    # calculates md5 from result of :init_payment_signature_string
    def init_payment_signature(invoice_id, amount, description, custom_options={})
      md5 init_payment_signature_string(invoice_id, amount, description, custom_options)
    end

    # generates signature string to calculate 'SignatureValue' url parameter
    def init_payment_signature_string(invoice_id, amount, description, custom_options={})
      custom_options_fmt = custom_options.sort.map{|x|"shp#{x[0]}=#{x[1]}"}.join(":")
      "#{@options[:login]}:#{amount}:#{invoice_id}:#{@options[:password1]}#{custom_options_fmt.blank? ? "" : ":" + custom_options_fmt}"
    end

    # returns http://test.robokassa.ru or https://merchant.roboxchange.com in order to current mode
    def base_url
      test_mode? ? 'http://test.robokassa.ru' : 'https://merchant.roboxchange.com'
    end

    # returns url to redirect user to payment page
    def init_payment_base_url
      "#{base_url}/Index.aspx"
    end

    def self.md5(str) #:nodoc:
      Digest::MD5.hexdigest(str).downcase
    end

    # Maps gem parameter names, to robokassa names
    def self.map_params(params, map)
      Hash[params.map do|key, value| [(map[key] || map[key.to_sym] || key), value] end]
    end

    def map_params(params, map) #:nodoc:
      self.class.map_params params, map
    end
  end
end
