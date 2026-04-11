require "crest"

class MissingHeaderError < Exception; end

class EndpointHandlers
  TOLK_FORWARD_HEADER = "Forward-To-Host"

  def handle_httppost(request : HTTP::Request)
    hosturl : String = request.headers[TOLK_FORWARD_HEADER]?.try(&.to_s) || raise MissingHeaderError.new("#{TOLK_FORWARD_HEADER} header is missing in request!")
    body : String = request.body.try(&.gets_to_end) || ""

    stripped_headers = request.headers.reject { |k, _| k == TOLK_FORWARD_HEADER }

    Crest.post(
      url: "#{hosturl}",
      form: body,
      headers: stripped_headers,
    )

    Log.info { "tolk: OK - Forwarded POST request to #{hosturl}" }
  end
end
