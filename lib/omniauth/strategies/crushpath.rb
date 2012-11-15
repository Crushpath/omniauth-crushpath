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
        contact = contact(raw_info)
        prune!({
          :nickname => get_vanity(raw_info['default_tenant_user']),
          :full_name => contact['display_name'],
          :image => contact['avatar_url'],
          :description => contact['title'],
          :company => get_company_name(contact),
          :email => contact['email'],
          :urls => {
             :tenant => get_tenant_subdomain(raw_info['default_tenant_user']),
             :company => get_company_website(contact),
              :crushpath => get_website(contact)
          },
          :recommendations => get_recommendations(raw_info)
        })
      end

      extra do
        prune!({:raw_info => raw_info})
      end

      def contact(raw_info)
        if raw_info['default_tenant_user'] and raw_info['default_tenant_user']['contact']
          return raw_info['default_tenant_user']['contact']
        end
        return raw_info['person']
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

      def get_recommendations(raw_info)
        raw_info['possible_recommendations'] || []
      end

      def get_vanity(tu)
        tu['vanity_path_name'] if tu
      end

      def get_tenant_subdomain(tu)
        if tu and tu['tenant'] and tu['tenant']['display_name']
          tu['tenant']['display_name'].gsub(/[\s\@]/, '-')
        end
      end


      def get_company(contact)
        contact['organization']
      end

      def get_website(contact)
        websites = contact['websites'] || []
        first_website = websites.first
        if first_website
          return first_website.site.split(' ').first
        end
      end

      def get_company_name(contact)
        comp = get_company(contact)
        return comp['display_name'] if comp
      end

      def get_company_website(contact)
        comp = get_company(contact)
        return comp['website'] if comp
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
