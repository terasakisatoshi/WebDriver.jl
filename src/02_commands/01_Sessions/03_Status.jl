# Command: Status
"""
	status(wd::WebDriver)::Bool
Returns `true` if the server is running and ready to accept new sessions.
"""
function status(wd::RemoteWebDriver)::Bool
    @unpack addr = wd
    response = HTTP.get("$addr/status", [("Content-Type" => "application/json; charset=utf-8")])
    @assert response.status == 200
    json = JSON3.read(response.body).value
    json.ready
end
