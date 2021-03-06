# SimpleTokenAuth

SimpleTokenAuth is similar to [`simple_token_authentication`](https://github.com/gonzalo-bulnes/simple_token_authentication). One of the differences is that it uses Rails' `authenticate_or_request_with_http_token` method for authentication like it mentioned [here](http://blog.envylabs.com/post/75521798481/token-based-authentication-in-rails). and it plays nice with authentication libraries like Devise. See usage examples below.

## Rails 5

Include the following to your controller if you are using Rails::API of Rails. This will have authenticate_or_request_with_http_token available.

```
class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  protected

  # http://stackoverflow.com/questions/17712359/authenticate-or-request-with-http-token-returning-html-instead-of-json
  def request_http_token_authentication(realm = "Application", message = nil)
    message ||= "HTTP Token: Access denied.\n"
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    unauthorized_error message
  end

  def unauthorized_error(message)
    render json: {error: message}, status: :unauthorized
  end
end
```

## Usage

First, ensure you already have a model to apply token authentication to, for example, a User model.

### Setting up things

1. Run `bin/rails g simple_token_auth:install` to create the initializer.
2. Run `bin/rails g simple_token_auth user` to create ApiKey model and make the user token authenticatable.

The initializer likes like this:

```ruby
SimpleTokenAuth.configure do |config|
  # Make sure `find_scope_strategy` always return a tuple [scope, token]
  config.find_scope_strategy = -> (scope_class, token) do
    field, token = token.split('.')
    scope = scope_class.find(field.to_i)
    [scope, token]
  end

  config.after_authenticated_strategy = -> (scope, controller) do
    # If you are using Devise, this will set up `current_user` for us
    controller.sign_in scope, store: false
  end

  # API key expires in some time
  config.expire_in = 3.hours
end
```

### Authenticate with token

Now authenticate the user with token!

```ruby
class ApplicationController
  include SimpleTokenAuth::AuthenticateWithToken
end

class UserController < ApplicationController
  prepend_before_action :authenticate_user_from_token!
end
```

### Renew API key

We should renew api key when user logs in via SessionsController for example

```ruby
class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    resource.renew_api_key
    sign_in(resource_name, resource, store: false)
    render json: resource
  end
end
```

## Licence

SimpleTokenAuth is released under the MIT license. See LICENSE for details.
