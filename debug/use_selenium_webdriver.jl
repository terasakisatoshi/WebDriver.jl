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

# New Session
session = Session(wd)
@test isa(session, Session)
# Delete Session
@test delete!(session) == session.id
session = Session(wd)
# Status
# @test status(wd)
# Get Timeouts
@test_broken timeouts(session)
# Set Timeouts
@inferred timeouts!(session, Timeouts(implicit = 50))
@inferred timeouts!(session, Timeouts())
# Navigate To
navigate!(session, "https://www.google.co.jp/")
start_url = current_url(session)
#=
@inferred navigate!(session, "http://thedemosite.co.uk/addauser.php")
# Get Current URL
@test current_url(session) == "http://thedemosite.co.uk/addauser.php"
# Back
back!(session)
@test current_url(session) == start_url
# Forward
forward!(session)
@test current_url(session) == "http://thedemosite.co.uk/addauser.php"
# Refresh
=#
@inferred refresh!(session)
# Get Title
navigate!(session, "https://www.google.co.jp/")
@test document_title(session) == "Google"
# Get Window Handle
@inferred window_handle(session)
# Close Window
@inferred window_close!(session)
delete!(session)
session = Session(wd)
# Switch to Window
window!(session, window_handle(session))
# Get Window Handles
@inferred window_handles(session)
# New Window
# @inferred window!(session)
# Switch to Parent Frame
@inferred parent_frame!(session)
# Get Window Rect
@inferred rect(session)
# Set Window Rect
o = rect!(session, width = 525, height = 489)
@test o.width == 525
@test o.height == 489
# Maximize Window
@inferred maximize!(session)
# Minimize Window
minimize!(session)
# Get Active Element
@inferred active_element(session)
# Find Element
navigate!(session, "http://book.theautomatedtester.co.uk/chapter1")