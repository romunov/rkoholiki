server <- function(input, output) {
  appImportFile <- reactive({
    if (!is.null(input$input_file_upload)) {
      fn <- input$input_file_upload$datapath
      xy <- read.table(file = fn, header = TRUE, sep = ";")
    } else {
      NULL
    }
  })
  
  # Finds uploaded file and renders a datatable.
  # Elements for menu Import data
  observe({
    xy <- appImportFile()
    if (!is.null(xy)) {
      output$uploaded_data <- renderDataTable({ datatable(xy) })
    } else {
      output$uploaded_data <- renderDataTable({ NULL })
    }
  })
  
  # Elements for plotting (menu Plot)
  observe({
    xy <- appImportFile()
    
    if (!is.null(xy)) {
      cn <- colnames(xy)
      cn <- cn[!grepl("Species", cn)] # remove "Species"
      
      output$plot_x <- renderUI({
        selectInput(inputId = "sel_x", label = "X axis", choices = cn)
      })
      
      output$plot_y <- renderUI({
        selectInput(inputId = "sel_y", label = "Y axis", choices = rev(cn))
      })
      
      output$plot_point_size <- renderUI({
        sliderInput(inputId = "slid", label = "Point size", min = 0.5, max = 5, value = 1)
      })
      
      output$plot_jitter <- renderUI({
        checkboxInput(inputId = "chk", label = "Jitter?", value = FALSE)
      })
    } else {
      output$plot_x <- renderUI({ NULL })
      output$plot_y <- renderUI({ NULL })
      output$plot_point_size <- renderUI({ NULL })
      output$chk <- renderUI({ NULL })
    }
  })
  
  # Render plot (menu Plot)
  observe({
    xy <- appImportFile()
    
    if (!is.null(xy)) {
      output$plot_display <- renderPlot({
        out <- ggplot(xy, aes_string(x = input$sel_x, 
                                     y = input$sel_y, 
                                     color = "Species")) +
          theme_bw() +
          geom_smooth(method = "lm")
        
        # add points or jitter, depending on the input of the checkbox
        if (input$chk == TRUE) {
          out + geom_jitter(size = input$slid)
        } else {
          out + geom_point(size = input$slid)
        }
        
      })
    } else {
      output$plot_display <- renderPlot({ NULL })
    }
  })
  
  # Render statistics (menu Summary)
  observe({
    xy <- appImportFile()
    
    output$stats <- renderUI({
      fluidRow(
        infoBox(title = "Number of data points", value = nrow(xy), icon = icon("mars"), color = "light-blue", width = 4),
        infoBox(title = "Number of species", value = length(unique(xy)), icon = icon("paw"), color = "olive", width = 4)
      )
    })
  })
}
