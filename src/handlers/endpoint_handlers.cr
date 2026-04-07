require "../services/ntfy.cr"

class EndpointHandlers
  def initialize
    @ntfy_service = Ntfy.new
  end

  def handle_webhook(message : String)
    @ntfy_service.send_message(message)
  end
end
