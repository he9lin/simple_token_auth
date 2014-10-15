SimpleTokenAuthorization.configure do |config|
  config.find_scope_strategy = -> (scope_class, token) do
    field, token = token.split('.')
    scope = scope_class.find(field.to_i)
    [scope, token]
  end

  config.after_authenticated_strategy = -> (scope, controller) do
    controller.sign_in scope, {}
  end
end
