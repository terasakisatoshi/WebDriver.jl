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

# +
using Revise
using Test

using DotEnv

using PythonCall
using CondaPkg
using WebDriver

webdriver = pyimport("selenium.webdriver")
# -

DotEnv.load!()

# +
driver = webdriver.Chrome()
command_executor_url = pyconvert(String, driver.command_executor._url)

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
navigate!(session, "https://www.linkedin.com/login?fromSignIn=true&trk=guest_homepage-basic_nav-header-signin")

username = Element(session, "username")
password = Element(session, "password")

element_key!(username, ENV["USERNAME"])
element_key!(password, ENV["PASSWORD"])


