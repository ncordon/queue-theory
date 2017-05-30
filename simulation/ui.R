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
library('mgcv')

shinyUI(fluidPage(
  navbarPage("Simulaciones de colas",
    tabPanel("D/D/1",
             sidebarLayout(
               sidebarPanel(
                 sliderInput("sim.dd1.time", "Simular hasta:",
                             min = 20, max = 3000, value = 100),
                 numericInput("arrival.dd1.freq", "Frecuencia de llegada:", value = 15, min = 0),
                 numericInput("service.dd1.freq", "Frecuencia de servicio:", value = 7, min = 0)
               ),


               mainPanel(
                 plotOutput("dd1.queue.usage"),
                 plotOutput("dd1.queue.wait"),
                 plotOutput("dd1.server.usage")
               ))
             ),
    tabPanel("M/M/1",
             sidebarLayout(
               sidebarPanel(
                 sliderInput("sim.mm1.time", "Simular hasta:",
                             min = 20, max = 3000, value = 100),
                 numericInput("arrival.mm1.freq", "Frecuencia de llegada:", value = 15, min = 0),
                 numericInput("service.mm1.freq", "Frecuencia de servicio:", value = 7, min = 0)
               ),
                mainPanel(
                  plotOutput("mm1.queue.usage"),
                  plotOutput("mm1.queue.wait"),
                  plotOutput("mm1.server.usage")
               ))
             ))
))
