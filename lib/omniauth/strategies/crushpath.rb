require 'omniauth-oauth2'

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
        websites = raw_info['person']['websites'] || []
        prune!({
          :nickname => raw_info['person']['display_name'],
          :full_name => raw_info['person']['display_name'],
          :image => raw_info['person']['avatar_url'],
          :description => raw_info['person']['title'],
          :email => raw_info['person']['email'],
          :urls => {
            :crushpath => websites.first,
            # TODO
            :pitch_site => raw_info['main_pitch_site']
          }
        })
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

      def build_access_token
        access_token = super
        token = eval(access_token.token)['token']
        @access_token = ::OAuth2::AccessToken.new(client, token, access_token.params)
      end

      def raw_info
        @raw_info ||= access_token.get('/users/~.json').parsed
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
