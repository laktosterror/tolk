require "crest"

class Ntfy
  def send_message(message : String)
    Crest.post(
      "https://ntfy.sh/#{NTFY_TOPIC}",
      message,
      logging: true
    )
  end
end
