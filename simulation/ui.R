##########################################################################
# Lista de paquetes a cargar
##########################################################################

### simmer -> paquete de simulación
### plot.simmer -> plot de simulaciones
### ggplot2 -> paquete para gráficas
### shiny -> render web
### shinythemes -> para poder usar theme united
library('simmer')
library('simmer.plot')
library('ggplot2')
library('shiny')
library('shinythemes')

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("sim.time", "Run simulation until:",
                  min = 20, max = 1000, value = 100),
      numericInput("arrival.freq", "Arrival frequency:", value = 15, min = 0),
      numericInput("service.freq", "Service frequency:", value = 7, min = 0)
    ),


    mainPanel(
      plotOutput("queue.usage"),
      plotOutput("queue.wait"),
      plotOutput("server.usage")
    )
  )
))
