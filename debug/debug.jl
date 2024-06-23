using Test, WebDriver
using WebDriver: StatusError
using Documenter
# DocMeta.setdocmeta!(WebDriver, :DocTestSetup, :(using WebDriver), recursive = true)

ENV["WEBDRIVER_HOST"] = get(ENV, "WEBDRIVER_HOST", "localhost")
ENV["WEBDRIVER_PORT"] = get(ENV, "WEBDRIVER_PORT", "4444")

#=
@testset "WebDriver" begin
    doctest(WebDriver)
end
=#

capabilities = Capabilities("chrome")
@test isa(capabilities, Capabilities)
wd = RemoteWebDriver(
    capabilities,
    host = ENV["WEBDRIVER_HOST"],
    port = parse(Int, ENV["WEBDRIVER_PORT"]),
    )
@test status(wd)
# New Session
session = Session(wd)
@test isa(session, Session)

# Navigate
navigate!(session, "https://www.google.co.jp/")
@test current_url(session) == "https://www.google.co.jp/"

# Delete Session
@test delete!(session) == session.id
@test_throws WDError delete!(session)
session = Session(wd)
# @show session.id

@test_throws WDError delete!(session)
session = Session(wd)

# Delete Session
@test delete!(session) == session.id
@show session.id
@test status(wd)