# Cargar paquetes
library(shiny)
library(shinydashboard)
library(readxl)
library(ggplot2)
library(dplyr)

# Cargar datos
Libertad <- readr::read_csv("Datos/datos_libertad.csv") 

# Convertir libertad_humana_puntaje, libertad_personal_puntaje y libertad_economica_puntaje a numérico
Libertad$libertad_humana_puntaje <- as.numeric(as.character(Libertad$libertad_humana_puntaje))
Libertad$libertad_personal_puntaje <- as.numeric(as.character(Libertad$libertad_personal_puntaje))
Libertad$libertad_economica_puntaje <- as.numeric(as.character(Libertad$libertad_economica_puntaje))

# Definir la interfaz de usuario
ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Libertades Mundiales"),
  dashboardSidebar(
    selectInput("pais_seleccionado", "Seleccione el país", choices = unique(Libertad$pais), selected = NULL),
    sliderInput("rango_anios", "Seleccione el rango de años:",
                min = min(Libertad$anio), max = max(Libertad$anio),
                value = c(min(Libertad$anio), max(Libertad$anio)),
                step = 1),
    radioButtons("tipo_datos", "Seleccione el tipo de dato:",
                 choices = c("Puntaje" = "puntaje", "Ranking" = "ranking"),
                 selected = "puntaje"),
    fluidRow(
      column(3, offset = 1, align = "center",
             downloadButton("descargar_datos", "Descargar Datos", class = "btn-primary")
      )
    )
  ),
  dashboardBody(
    tabBox(
      title = "Libertades Mundiales",
      id = "tabset1",
      tabPanel("Libertad Personal", plotOutput("libertad_personal_plot")),
      tabPanel("Libertad Humana", plotOutput("libertad_humana_plot")),
      tabPanel("Libertad Económica", plotOutput("libertad_economica_plot"))
    ),
  )
)

# Definir el servidor
server <- function(input, output, session) {
  datos_reactivos <- reactive({
    read_csv("Datos/datos_libertad.csv")
  })
  output$libertad_personal_plot <- renderPlot({
    data <- subset(Libertad, pais == input$pais_seleccionado & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_personal_puntaje", "libertad_personal_ranking")
    plot(data$anio, data[[columna]], type = 'l',
         main = paste("Libertad Personal en", input$pais_seleccionado, "a lo largo de los años seleccionados"),
         xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
  
  output$libertad_humana_plot <- renderPlot({
    data <- subset(Libertad, pais == input$pais_seleccionado & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_humana_puntaje", "libertad_humana_ranking")
    plot(data$anio, data[[columna]], type = 'l',
         main = paste("Libertad Humana en", input$pais_seleccionado, "a lo largo de los años seleccionados"),
         xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
  
  output$libertad_economica_plot <- renderPlot({
    data <- subset(Libertad, pais == input$pais_seleccionado & between(anio, input$rango_anios[1], input$rango_anios[2]))
    columna <- ifelse(input$tipo_datos == "puntaje", "libertad_economica_puntaje", "libertad_economica_ranking")
    plot(data$anio, data[[columna]], type = 'l',
         main = paste("Libertad Económica en", input$pais_seleccionado, "a lo largo de los años seleccionados"),
         xlab = "Año", ylab = ifelse(input$tipo_datos == "puntaje", "Puntaje", "Ranking"))
  })
  
  output$descargar_datos <- downloadHandler(
    filename = function() {
      paste("graficos_", input$pais_seleccionado, "_", input$tipo_datos, "_", input$rango_anios[1], "_", input$rango_anios[2], ".zip", sep = "")
    },
    content = function(file) {
      data <- subset(Libertad, pais == input$pais_seleccionado & between(anio, input$rango_anios[1], input$rango_anios[2]))
      write.csv(data, file, row.names = FALSE)
    }
  )
}

# Ejecutar la aplicación
shinyApp(ui, server)
