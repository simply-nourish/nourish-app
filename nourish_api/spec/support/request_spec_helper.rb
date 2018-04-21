# request spec helpers
# /spec/support/request_spec_helper.rb
# source: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

module RequestSpecHelper

  # create json method to shorten JSON.parse syntax
  def json
    JSON.parse(response.body)
  end

end