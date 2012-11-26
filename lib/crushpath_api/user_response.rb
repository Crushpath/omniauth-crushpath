module CrushpathApi
  class UserResponse

    def initialize(raw_info)
      @raw_info = raw_info
      @contact = get_contact
      @tu = @raw_info['default_tenant_user']
    end

    def parse
      {
        :nickname => get_vanity,
        :full_name => @contact['display_name'],
        :paid => @tu['paid'] || false,
        :image => @contact['avatar_url'],
        :description => @contact['title'],
        :company => get_company_name,
        :email => @contact['email'],
        :company_description => get_company_description,
        :phone => phone,
        :urls => {
            :tenant => get_tenant_subdomain,
            :company => get_company_website,
            :crushpath => get_website
        },
        :recommendations => get_recommendations
      }
    end

    def get_contact
      if @raw_info['default_tenant_user'] and @raw_info['default_tenant_user']['contact']
        return @raw_info['default_tenant_user']['contact']
      end
      return @raw_info['person']
    end

    def get_recommendations
      @raw_info['possible_recommendations'] || []
    end

    def get_vanity
      @tu['vanity_path_name'] if @tu
    end

    def get_tenant_subdomain
      if @tu and @tu['tenant'] and @tu['tenant']['display_name']
        @tu['tenant']['display_name'].gsub(/[\s\@]/, '-')
      end
    end

    def get_company
      @contact['organization']
    end

    def get_website
      websites = @contact['websites'] || []
      first_website = websites.first
      if first_website
        return first_website['site'].split(' ').first
      end
    end

    def get_company_name
      comp = get_company
      return comp['display_name'] if comp
    end

    def get_company_description
      comp = get_company
      comp['summary'] if comp
    end

    def get_company_website
      comp = get_company
      if comp
        website = comp['website']

        if website !~ /^http/
          website = "http://#{website}"
        end
        return website
      end
    end

    def phone
      phones = @contact['phone_numbers'] || []
      first_phone = phones.first
      if first_phone
        return first_phone['number'].gsub(/[^0-9\+]/, '')
      end
    end
  end
end