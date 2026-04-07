require "kemal"
require "./handlers/endpoint_handlers.cr"

NTFY_TOPIC = ENV["NTFY_TOPIC"]

handlers = EndpointHandlers.new

post "/webhook" do |env|
  message = env.request.body.try(&.gets_to_end) || ""
  handlers.handle_webhook(message)
end

get "/health" do
  "OK"
end

Kemal.run
