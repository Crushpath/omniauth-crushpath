require 'omniauth-oauth2'
require_relative "../../crushpath_api/user_response"

module OmniAuth
  module Strategies
    class Crushpath < OmniAuth::Strategies::OAuth2

      option :name, 'crushpath'

      option :client_options, {
        :site => 'https://deals.crushpath.com',
        :authorize_url => '/authorization',
        :token_url => '/token'
      }

      uid { raw_info['id'] }

      info do
        resp = CrushpathApi::UserResponse.new(raw_info)
        prune!(resp.parse)
      end

      extra do
        prune!({:raw_info => raw_info})
      end

      def request_phase
        options[:response_type] ||= 'code'
        super
      end

      def callback_phase
        request.params['state'] = session['omniauth.state']
        super
      end

      def raw_info
        @raw_info ||= access_token.get('/users/~.json?skip=person').parsed
      end

      private

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

    end
  end
end
