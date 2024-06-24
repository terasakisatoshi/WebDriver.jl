# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.2
#   kernelspec:
#     display_name: Julia 1.10.4
#     language: julia
#     name: julia-1.10
# ---

using Revise

# +
using Test

using DotEnv

using PythonCall
using CondaPkg
using WebDriver

webdriver = pyimport("selenium.webdriver")
By = pyimport("selenium.webdriver.common.by").By
# -

# Prepare `.env` file and store `USERNAME` and `PASSWORD`
DotEnv.load!()

# +
driver = webdriver.Chrome() # Python object
command_executor_url = pyconvert(String, driver.command_executor._url)::String

m = match(r"http://[^:]+:(?P<port>\d+)", command_executor_url)
_port = m.captures |> only
m = match(r"http://(?P<hostname>[^:]+)", command_executor_url)
host = m.captures |> only

port = parse(Int, _port)

capabilities = Capabilities("chrome")

wd = RemoteWebDriver(
    capabilities;
    host, port
)

# New Session
session = Session(wd)
# -

#Open login page
navigate!(session, "https://www.linkedin.com/login")

# +
username = Element(session, "css selector", "username")
password = Element(session, "css selector", "password")
login_button = Element(session, "class name", "btn__primary--large")
sleep(rand())
element_keys!(username, ENV["USERNAME"])
sleep(rand())
element_keys!(password, ENV["PASSWORD"])
sleep(rand())
click!(login_button)
# -

navigate!(session, "https://www.linkedin.com/company/the-julia-language/posts/")

SCROLL_PAUSE_TIME = 1.5
MAX_SCROLLS = false
SCROLL_COMMAND = "window.scrollTo(0, document.body.scrollHeight);"
GET_SCROLL_HEIGHT_COMMAND = "return document.body.scrollHeight"
last_height = script!(session, GET_SCROLL_HEIGHT_COMMAND)
scrolls = 0
no_change_count = 0
for _ in 1:5
    global no_change_count, last_height, scrolls
    script!(session, SCROLL_COMMAND)
    sleep(SCROLL_PAUSE_TIME)
    new_height = script!(session, GET_SCROLL_HEIGHT_COMMAND)
    # Increment no change count or reset it
    no_change_count = new_height == last_height ?  no_change_count + 1 : 0
    # Break loop if the scroll height has not changed for 3 cycles or reached the maximum scrolls
    if no_change_count >= 3 || (MAX_SCROLLS && scrolls >= MAX_SCROLLS)
        break
    end
    last_height = new_height
    scrolls += 1
end

company_page = source(session)

open("soup.html", "w") do io
    println(io, company_page)
end


