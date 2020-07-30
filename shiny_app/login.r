
# --- Main login screen

# Author : yd0010@20143311
# Date : 2020-07-28
# Tidyverse Coding Style

## --- 0 Packages ---

library(shiny)
library(shinydashboard)
library(DT)
library(shinyjs)
library(sodium)

## --- 1. Set Login Page ---

loginpage <- div(
  id = "loginpage", style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
  wellPanel(
    tags$h2("LOG IN", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
    textInput("userName", placeholder = "Username", label = tagList(icon("user"), "Username")),
    passwordInput("passwd", placeholder = "Password", label = tagList(icon("unlock-alt"), "Password")),
    br(),
    div(
      style = "text-align: center;",
      actionButton("login", "SIGN IN", style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
      shinyjs::hidden(
        div(
          id = "nomatch",
          tags$p("Oops! Incorrect username or password!",
            style = "color: red; font-weight: 600; 
                                            padding-top: 5px;font-size:16px;",
            class = "text-center"
          )
        )
      ),
      br(),
      br(),
      tags$code("Username: myuser  Password: mypass"),
      br(),
      tags$code("Username: myuser1  Password: mypass1")
    )
  )
)

credentials <- data.frame(
  username_id = c("myuser", "myuser1"),
  passod = sapply(c("mypass", "mypass1"), password_store),
  permission = c("basic", "advanced"),
  stringsAsFactors = F
)
