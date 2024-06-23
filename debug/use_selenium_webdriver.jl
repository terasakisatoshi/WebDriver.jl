using Revise
using Test

using PythonCall
using CondaPkg
using WebDriver

CondaPkg.add_pip("selenium")
webdriver = pyimport("selenium.webdriver")

driver = webdriver.Chrome()
command_executor_url = pyconvert(String, driver.command_executor._url)

m = match(r"http://[^:]+:(?P<port>\d+)", command_executor_url)
_port = m.captures |> only
m = match(r"http://(?P<hostname>[^:]+)", command_executor_url)
host = m.captures |> only

port = parse(Int, _port)

capabilities = Capabilities("chrome")
@test isa(capabilities, Capabilities)

wd = RemoteWebDriver(
    capabilities;
    host, port
)

@test status(wd)
# New Session
session = Session(wd)
@test isa(session, Session)

@test session.id in sessions(wd)

@test current_url(session) == "data:,"
# Navigate
navigate!(session, "https://www.google.co.jp/")
@test current_url(session) == "https://www.google.co.jp/"
back!(session)
@test current_url(session) == "data:,"
forward!(session)

# Delete Session
session_id = session.id
@test delete!(session) == session.id

@test !(session_id in sessions(wd))

@test_throws WDError delete!(session)
session = Session(wd)
# @show session.id

@test_throws WDError delete!(session)
session = Session(wd)

# Delete Session
@test delete!(session) == session.id
@show session.id
@test status(wd)
