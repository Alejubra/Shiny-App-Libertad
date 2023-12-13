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

# server.R
server <- function(input, output) {
  # ... tu código del servidor aquí ...
}

# Crear la aplicación Shiny
shinyApp(ui = ui, server = server)