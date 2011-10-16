require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Facebook < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://graph.facebook.com',
        :token_url => '/oauth/access_token'
      }

      option :token_params, {
        :parse => :query
      }

      option :access_token_options, {
        :header_format => 'OAuth %s',
        :param_name => 'access_token'
      }
      
      uid { raw_info['id'] }
      
      info do
        {
          'nickname' => raw_info['username'],
          'email' => raw_info['email'],
          'first_name' => raw_info['first_name'],
          'last_name' => raw_info['last_name'],
          'image' => "http://graph.facebook.com/#{uid}/picture"
        }
      end

      def build_access_token
        super.tap do |token|
          token.options.merge!(access_token_options)
        end
      end

      def access_token_options
        options.access_token_options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
      end
    end
  end
end