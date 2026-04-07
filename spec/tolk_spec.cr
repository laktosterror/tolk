require "./spec_helper"
require "../src/handlers/endpoint_handlers"

describe EndpointHandlers do
  it "sends message" do
    handlers = EndpointHandlers.new
    handlers.handle_webhook("test").should be_true
  end
end
