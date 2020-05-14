
# Covid19 Shiny Dashboard. 
# Written by : Sofia Nicklaus S.
# Department of Business statistics, Matana University (Tangerang)
# ----------------------------------------------------------------------------------------

library(ggplot2)
library(plotly)
library(shiny)                                          
library(markdown)


#covid19 = read.csv('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv')  
#write.csv(covid19,'datacovid.csv')

#Covid1920 = read.csv("D:/sofia/smstr 4/setelah uts/sistem data base/pert 14/Covid1920.csv")

#Covid1920 = select(Covid1920, Country = location, Region = region, Week=week, Positive= total_cases, Death=total_deaths)



# ----------------------------------------------------------------------------------------------------------------------------


ui<-navbarPage("Covid 19 Dashboard Based on WHO",
               tabPanel("Covid19",titlePanel("Cases"), 
                        sidebarLayout(
                            sidebarPanel(DT::dataTableOutput("table1"),
                                         downloadButton("downloadData", "Download Data", href = "https://raw.githubusercontent.com/sofia3484/CSD-Rshiny/master/Covid1920.csv")),
                            mainPanel(tableOutput("table1`")))),
               
               tabPanel("Visualization",plotlyOutput("plot")),
               
               tabPanel("Help", 
                        titlePanel("Please contact:"), 
                        helpText("Sofia Nicklaus S. ~ Student of 
               Department of Business Statistics, Matana University (Tangerang) "),
                        sidebarLayout(
                            sidebarPanel(
                                downloadButton("downloadCode", "Download Code", href = "https://github.com/sofia3484/CSD-Rshiny/blob/master/app.R")),
                            mainPanel(tableOutput("table"))))
)

# C.2 Server ----
server<-function(input, output, session) {
    output$table1 <- DT::renderDataTable({DT::datatable(Covid1920)})
    output$plot <- renderPlotly(
        {ggplotly(ggplot(Covid1920, aes(Positive, Death, color = Region)) +
                      geom_point(aes(size = Death, frame = Week, ids = Country)) +
                      scale_x_log10())%>% 
                animation_opts(1000,easing="elastic",redraw=FALSE)})
    
    datasetInput <- reactive({switch(input$dataset, 
                                     "Covid1920"= Covid1920)})
    output$table <- renderTable({datasetInput()})
    output$downloadData <- downloadHandler(filename = function() {paste(input$dataset, ".csv",sep = "")},
                                           content = function(file) {write.csv2(datasetInput(), file, row.names = FALSE)})
    
    
    
    
    
    
}

shinyApp(ui, server)      # This is execute your apps
