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
          :nickname => get_vanity(raw_info['default_tenant_user']),
          :full_name => raw_info['person']['display_name'],
          :image => raw_info['person']['avatar_url'],
          :description => raw_info['person']['title'],
          :company => get_company(raw_info['person']),
          :email => raw_info['person']['email'],
          :urls => {
             :tenant => get_tenant_subdomain(raw_info['default_tenant_user']),
            :crushpath => websites.first
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

      def raw_info
        @raw_info ||= access_token.get('/users/~.json').parsed
      end

      def get_vanity(tu)
        tu['vanity_path_name'] if tu
      end

      def get_tenant_subdomain(tu)
        if tu and tu['tenant'] and tu['tenant']['display_name']
          tu['tenant']['display_name'].gsub(/[\s\@]/, '-')
        end
      end

      def get_company(person)
        if person and person['main_job'] and person['main_job']['organization']
          person['main_job']['organization']['display_name']
        end
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
