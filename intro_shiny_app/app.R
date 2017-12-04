library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)


header <- dashboardHeader(title = "Basic shiny app")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Import data", tabName = "sidebar_import", icon = icon("map-o")),
    menuItem("Plot", tabName = "sidebar_plot", icon = icon("eye")),
    menuItem("Summary", tabName = "sidebar_summary", icon = icon("cogs"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "sidebar_import",
            fluidRow(
              column(3,
                     fileInput(inputId = "input_file_upload", 
                               label = "Upload file", 
                               accept = c("text/csv", "text/txt"),
                               buttonLabel = "Upload")
              ),
              column(9,
                     dataTableOutput("uploaded_data"))
            )
    ),
    tabItem(tabName = "sidebar_plot",
            fluidRow(
              column(3, uiOutput("plot_x")),
              column(3, uiOutput("plot_y")),
              column(4, uiOutput("plot_point_size")),
              column(2, uiOutput("plot_jitter"))
            ),
            fluidRow(
              column(12,
                     plotOutput("plot_display"))
            )
    ),
    tabItem(tabName = "sidebar_summary",
            uiOutput("stats"))
  )
)

ui <- dashboardPage(header, sidebar, body, skin = "black")

source("./R/server.R", local = TRUE)

shinyApp(ui, server)
