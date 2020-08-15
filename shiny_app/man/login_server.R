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