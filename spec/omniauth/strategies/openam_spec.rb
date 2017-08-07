require 'spec_helper'

RSpec.describe OmniAuth::Strategies::OpenAM, type: :strategy do
  include OmniAuth::Test::StrategyTestCase

  let :token do
    "AQIC5wM2LY4SfcxuxIP0VnP2lVjs7ypEM6VDx6srk56CN1Q.*AAJTSQACMDE.*"
  end

  let :strategy do
    [OmniAuth::Strategies::OpenAM, "https://example.com/opensso", options]
  end

  let :options do
    {}
  end

  describe '/auth/openam' do
    it 'redirects to OpenAM login page' do
      get '/auth/openam'
      expect(last_response).to be_redirect
      expect(last_response.headers['Location']).to \
        eq(
          'https://example.com/opensso'\
          '?goto=http://example.org/auth/openam/callback'
        )
    end

    context 'with login_url' do
      let :options do
        { login_url: 'https://example.com/CustomLogin' }
      end

      it 'redirects to OpenAM login page' do
        get '/auth/openam'
        expect(last_response).to be_redirect
        expect(last_response.headers['Location']).to \
          eq(
            'https://example.com/CustomLogin'\
            '?goto=http://example.org/auth/openam/callback'
          )
      end
    end
  end

  describe '/auth/openam/callback' do
    before do
      stub_request(:post, "https://example.com/opensso/identity/attributes").
        with(body: { subjectid: token }).
        to_return(body: File.read(
            File.expand_path(
              '../../../fixtures/identity_attributes.txt', __FILE__
            )
          )
        )
    end

    it 'retrieves identity attributes' do
      get '/auth/openam/callback',
        {},
        { "HTTP_COOKIE" => "iPlanetDirectoryPro=#{token}" }
      auth = last_request.env['omniauth.auth']
      puts auth.inspect
      expect(auth[:credentials][:token]).to eq(token)
      expect(auth[:uid]).to eq('bjensen')
      expect(auth[:info][:email]).to eq('bjensen@example.com')
    end
  end
end
