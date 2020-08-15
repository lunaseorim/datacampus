#' form_login
#' @export 
form_login <- function(id, label_user, label_pw){
  ns <- NS(id)
  div(class = "ui form",
      div(class = "field",
          label(label_user),
          div(class = "ui left icon input", id = ns("frame_user"),
              HTML('<i class="ui user icon"></i>'),
              shiny::tags$input(id = ns("username"), type = "text", value = "" , placeholder = label_user)
          )
      ),
      div(class = "field",
          label(label_pw),
          div(class = "ui left icon input", id = ns("frame_pw"),
              HTML('<i class="ui key icon"></i>'),
              shiny::tags$input(id = ns("pw"), type = "password", value = "" , placeholder = label_pw)
          )
      ),
      div(class = "ui fluid button action-button", id = ns("login"), HTML('<i class="ui unlock alternate icon"></i>'))
  )
}


clickjs <- '$(document).keyup(function(event) {
    if (event.key == "Enter") {
        $("#user-login").click();
    }
});'

#' login_ui
#' @export 
login_ui <- function(id, head = NULL, signin = T, recover = F, label_user = "User", label_pw = "Password"){
  
  ns <- NS(id)
  
  tagList(
    shinyjs::useShinyjs(),
    div(class = "ui inverted active page dimmer",  style = "background-color:#e0e1e2;",
        div(class = "ui card", align = "left", id = ns("checkin"), #style = "margin-top: 10%;",
            div(class = "content",
                head,
                div(class="ui accordion", id = "checkin_options",
                    div(class = "active title", id = "default_title",
                        HTML('<i class="ui dropdown icon"></i>'),
                        "Login"
                    ),
                    div(class="active content", id = "default_content",
                        form_login(id, label_user, label_pw)
                    )
                )
            )
        )
    ),
    shiny::tags$script("$('.dimmer').dimmer({closable: false}).dimmer('show');"),
    # https://stackoverflow.com/questions/32335951/using-enter-key-with-action-button-in-r-shiny
    shiny::tags$script(clickjs)
  )
}

#' checkin_feedback
#' @export
checkin_feedback <- function(msg = ""){
  if(msg == "") return(NULL)
  if(is.null(msg)) return(NULL)
  header <- str_remove(msg, ":.*?$")
  content <- str_remove(msg, "^.*?: ")
  
  if(str_detect(msg, "Fail")){
    out <- tagList(
      div(class="ui attached icon warning message",
          HTML('<i class="close icon"></i>'),
          div(class="content",
              div(class="ui header",
                  header
              ),
              content
          )
      )
    )
  } else if(str_detect(msg, "Success")){ 
    out <- tagList(
      div(class="ui attached icon positive message",
          HTML('<i class="close icon"></i>'),
          div(class="content",
              div(class="ui header",
                  header
              ),
              content
          )
      )
    )
  } else {
    out <- tagList(
      div(class="ui attached icon info message",
          HTML('<i class="close icon"></i>'),
          div(class="content",
              div(class="ui header",
                  header
              ),
              content
          )
      )
    )
  }
  
  tagList(
    out, 
    shiny::tags$script("$('.message .close')
      .on('click', function() {
        $(this)
          .closest('.message')
          .transition('fade')
        ;
      })
    ;")
  )
}

#' login_server
#' @export
login_server <- function(input, output, session, users){
  
  new <- reactive({
    user$new(users()) 
  })
  
  observeEvent(input$login ,{
    shinyjs::addClass("buffer", "active")
    new()$login(input$username, input$pw)
    shinyjs::delay(1000, shinyjs::removeClass("buffer", "active"))
  })
  
  observeEvent(input$logout ,{
    
    shinyjs::addClass("buffer", "active")
    shinyjs::runjs("history.go(0);")
    # new()$logout()
    # new()$reset() 
  })
  
  observeEvent(input$recover, {
    new()$recover(input$recover_email)
  })
  
  observeEvent(input$signin ,{
    new()$register(input$user, input$pw1, input$pw2)
  })
  
  # output$message <- renderUI({
  #   input$login
  #   input$logout
  #   input$signin
  #   input$recover
  #   checkin_feedback(new()$session$message)
  # })
  
  observeEvent({input$login | input$signin | input$logout}, { 
    # req(new())
    if(new()$session$status == 1) {
      
      shinyjs::show("checkmark")
      shinyjs::hide("checkin")
      shinyjs::delay(1400, shinyjs::runjs("$('#user-checkmark').dimmer({transition: 'vertical flip'}).dimmer('hide');"))
      shinyjs::delay(1500, shinyjs::runjs("$('.dimmer').dimmer('hide');"))
      
    } else {
      
      shinyjs::addCssClass("frame_user", "error")
      shinyjs::addCssClass("frame_pw", "error")
      shinyjs::runjs("$('#user-checkin').transition('shake');")
      shinyjs::delay(2000, shinyjs::removeCssClass("frame_user", "error"))
      shinyjs::delay(2000, shinyjs::removeCssClass("frame_pw", "error"))
      
    }
  }, ignoreInit = T)
  
  out <- eventReactive({input$login | input$signin}, {
    
    if(new()$session$status == 1) {
      return(as.list(new()$session))
    } else {
      return(NULL)
    }
  })
  
  return(out)
}

#' manager_ui
#' @export
manager_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("options")),
    admin_ui(ns("admin"))
  )
}

#' manager_server
#' @export
manager_server <- function(input, output, session, user){
  
  output$options <- renderUI({
    req(user())
    if(is.null(user()$role)) return(NULL)
    #browser()
    dropdownMenu(
      type = "notifications", 
      icon = icon("user"), 
      show_counter = F,
      # div(class = "item", style = "min-width: 150px;",
      #     theme_ui(session$ns("theme"))
      # ),
      div(class = "action-button item", style = "min-width: 150px;", id = "account",
          icon("user"), "Your Account"
      ),
      if(user()$role == "admin"){
        list(
          div(class = "action-button item", style = "min-width: 150px;", id = "manager-admin-show",
              icon("cogs"), "Admin Panel"
          ),
          div(class="ui divider"),
          ### this triggers the logout inside login_mod
          div(class = "action-button item", style = "min-width: 150px;", id = "user-logout", 
              icon("power off"), "Logout"
          )
        )
      } else {
        ### this triggers the logout inside login_mod
        div(class = "action-button item", style = "min-width: 150px;", id = "user-logout", 
            icon("power off"), "Logout"
        )
      }
    )
  })
  
  # callModule(admin_server, "admin", user)
  # callModule(theme_server, "theme")
}

#' admin_ui
#' @export
admin_ui <- function(id){
  ns <- NS(id)
  tagList(
    # div(class="ui modal", id = "user-details",
    # 
    # ),
    #div(class="ui modal", id = "admin-modal",
    span(class = "ui header",
         "Admin Panel"
    ),
    #actionButton(session$ns("back"), class = "ui right floated basic inverted circular icon button", label = "", icon = icon("remove")),
    div(class = "scrolling content", #align = "left", style = "width: 80%; min-height: 100vh;",
        div(class = "ui stackable grid",
            div(class = "row",
                div(class = "two wide column",
                    shiny::actionButton(inputId = ns("new_user"), label = "", class = "ui green compact icon button", icon = icon("user plus"))
                ),
                div(class="four wide column",
                    dropdown(name = "sortby", choices = c("admin", "client"), value = "role")
                ),
                div(class = "six wide column",
                    uiOutput(ns("search_user_selection"))
                )
            ),
            div(class = "row",
                div(class = "sixteen wide column",
                    DT::DTOutput(ns("list"))
                )
            )
        ),
        div(class = "ui divider"),
        div(class = "ui form",
            div(class = "fields",
                div(class = "field",
                    textInput(ns("username"), label = "", value = "")
                ),
                div(class = "field",
                    textInput(ns("pw"), label = "", value = "") 
                )
            )    
        )
        #)
    )
  )
}

#' admin_server
#' @export
admin_server <- function(input, output, session, users){
  
  output$search_user_selection <- renderUI({
    shiny.semantic::search_selection_choices(
      name = session$ns("search_user"),
      choices = users()$username,
      value = NULL,
      multiple = T
    )
  })
  
  output$list <- DT::renderDT({
    req(users())
    DT::datatable(users(), selection = list(mode = "single"))
  })
  
  selected <- reactive({
    req(input$list_rows_selected)
    
    target <- input$list_rows_all[which(input$list_rows_all %in% input$list_rows_selected)]
    users() %>%
      dplyr::slice(target)
  })
  
  observeEvent({input$list_rows_selected},{
    shinyjs::runjs("$('#user-details').modal('show');")
  }, ignoreInit = T)
  
  observe({
    glimpse(selected())
  })
  
  outputOptions(output, "list", suspendWhenHidden = F)
}
