# auth helper methods for unit testing
# adapted from: https://github.com/lynndylanhurley/devise_token_auth/issues/521

module AuthHelper

    # Request helper: creates user auth tokens, builds + makes request
    module Request
        %i(get post put delete).each do |http_method|

            # define method for each of these HTTP request types, fills http header / body
            # with data, sends it to specified endpoint / action:
            define_method("auth_#{http_method}") do |user, action_name, params: {}, headers: {}|
              auth_headers = user.create_new_auth_token
              headers = headers.merge(auth_headers)
              public_send(http_method, action_name, params: params, headers: headers)
            end

        end

    end
end