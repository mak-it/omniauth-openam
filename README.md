# OmniAuth OpenAM

[![Continuous Integration status](https://secure.travis-ci.org/mak-it/omniauth-openam.png)](http://travis-ci.org/mak-it/omniauth-openam)

OmniAuth strategy for authenticating to [OpenAM](https://www.forgerock.com/products/access-management/).

## Installation

Add to your `Gemfile`:

```ruby
gem 'omniauth-openam'
```

## Usage

Here's a quick example, adding the middleware to a Rails app
in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openam, 'https://example.com/opensso'
end
```

## Auth Hash

Here's an example Auth Hash available in request.env['omniauth.auth']:

```ruby
{
  provider: "openam",
  uid: "bjensen",
  info: {
    email: "bjensen@example.com",
    first_name: "Barbara",
    last_name: "Jensen",
    name: "Babs Jensen",
    username: "bjensen",
  },
  credentials: {
    token: "AQIC5wM2LY4SfcxuxIP0VnP2lVjs7ypEM6VDx6srk56CN1Q.*AAJTSQACMDE.*"
  },
  extra: {
    raw_info: {
      token: "AQIC5wM2LY4SfcxuxIP0VnP2lVjs7ypEM6VDx6srk56CN1Q.*AAJTSQACMDE.*",
      cn: ["Babs Jensen", "Barbara Jensen"],
      dn: ["uid=bjensen,ou=people,dc=example,dc=com"],
      givenname: ["Barbara"],
      mail: ["bjensen@example.com"],
      objectclass: ["organizationalPerson", "person", "posixAccount", "inetOrgPerson", "krbprincipalaux", "krbTicketPolicyAux", "top"],
      sn: ["Jensen"],
      telephonenumber: ["+1 408 555 1862"],
      uid: ["bjensen"]
    }
  }
}
```
