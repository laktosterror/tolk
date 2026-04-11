require "kemal"
require "./handlers/endpoint_handlers.cr"

handlers = EndpointHandlers.new

post "/httppost" do |env|
  handlers.handle_httppost(env.request)
rescue e : MissingHeaderError
  Log.error { "tolk: #{e.message}" }
  halt env, status_code: 400, response: e.message.to_s
end

get "/health" do
  "OK"
end

Kemal.run
