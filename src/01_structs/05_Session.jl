"""
	Session

This is a web session.

```jldoctest
julia> capabilities = Capabilities("chrome")
Remote WebDriver Capabilities
browserName: chrome
julia> wd = RemoteWebDriver(capabilities, host = ENV["WEBDRIVER_HOST"], port = parse(Int, ENV["WEBDRIVER_PORT"]))
Remote WebDriver
julia> session = Session(wd)
Session
julia> isa(session, Session)
true
julia> delete!(session);

```
"""
struct Session{D<:Object}
    addr::String
    id::String
    attrs::D
    function Session(wd::RemoteWebDriver)
        addr = wd.addr
        url = "http://localhost:4444/session"
        headers = Dict(
            "Accept" => "application/json",
            "Content-Type" => "application/json;charset=UTF-8",
            # "User-Agent" => "selenium/4.22.0.dev202405160507 (python mac)",
            "Connection" => "keep-alive",
        )
        _body = Dict(
          "capabilities" => Dict(
            "firstMatch" => [Dict()],
            "alwaysMatch" => Dict(
              "browserName" => "chrome",
              "pageLoadStrategy" => "normal",
              "goog:chromeOptions" => Dict(
                "extensions" => [],
                "args" => []
              )
            )
          )
        )
        response = HTTP.post(
                url,
                headers,
                body=JSON3.write(_body)
        )

        @info  response.status
        @assert response.status == 200
        data = JSON3.read(response.body)
        new{typeof(data.value)}(addr, data.value.sessionId, data.value)
    end
end

broadcastable(obj::Session) = Ref(obj)
Base.summary(io::IO, obj::Session) = println(io, "Session")
function Base.show(io::IO, obj::Session)
    print(io, summary(obj))
end
