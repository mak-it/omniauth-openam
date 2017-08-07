require 'omniauth'
require 'faraday'

module OmniAuth
  module Strategies
    class OpenAM
      include OmniAuth::Strategy

      args [:auth_url]

      option :cookie_name, 'iPlanetDirectoryPro'
      option :login_url, nil

      attr_reader :token

      uid do
        raw_info['uid'][0]
      end

      info do
        {
          username:   raw_info['uid'][0],
          email:      raw_info['mail'][0],
          first_name: raw_info['givenname'][0],
          last_name:  raw_info['sn'][0],
          name:       raw_info['cn'][0]
        }
      end

      credentials do
        {
          token: token
        }
      end

      extra do
        {
          raw_info: raw_info
        }
      end

      protected

      def request_phase
        login_url = options[:login_url] || options[:auth_url]
        redirect "#{login_url}?goto=#{callback_url}"
      end

      def callback_phase
        @token = request.cookies[options[:cookie_name]]
        if token.nil?
          e = RuntimeError.new("#{options[:cookie_name]} cookie is missing")
          return fail!(:invalid_credentials, e)
        end
        if raw_info.empty?
          e = RuntimeError.new("Identity attributes are empty")
          return fail!(:invalid_credentials, e)
        end
        super
      end

      def raw_info
        @raw_info ||= begin
          conn = Faraday.new(url: options[:auth_url]) do |faraday|
            faraday.request  :url_encoded
            faraday.response :logger, OmniAuth.logger
            faraday.adapter Faraday.default_adapter
          end
          response = conn.post(
            "#{URI(options[:auth_url]).path}/identity/attributes",
            subjectid: token
          )
          attributes = Hash.new{ |h,k| h[k] = [] }
          name = nil
          lines = response.body.split("\n")
          lines.each do |line|
            key, value = line.split("=", 2)
            case key
            when 'userdetails.token.id'
              attributes['token'] = value
            when 'userdetails.attribute.name'
              name = value
            when 'userdetails.attribute.value'
              attributes[name] << value
            end
          end
          attributes
        end
      end
    end
  end
end

OmniAuth.config.add_camelization 'openam', 'OpenAM'
