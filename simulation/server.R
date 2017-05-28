# Limpieza del entorno
rm(list = ls())


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


##########################################################################
# Resultados
##########################################################################
function(input, output){
  dataInput <- reactive({
    sim.time <- input$sim.time

    lambda <- input$arrival.freq
    mu <- input$service.freq

    # Parametros no vacios y no nulos
    req(lambda > 0)
    req(mu > 0)

    dd1.trajectory <- trajectory() %>%
      seize("caja del súper", amount=1) %>%
      timeout(function(){ mu }) %>%
      release("caja del súper", amount=1)


    dd1.env <- simmer() %>%
      add_resource("caja del súper", capacity=1, queue_size=Inf) %>%
      add_generator("llegadas", dd1.trajectory, function(){ lambda })


    dd1.env %>% run(until=sim.time)

    list( dd1 = dd1.env, sim.time = sim.time)
  })





  # Utilizacion de la cola
  output$queue.usage <- renderPlot({
    args <- dataInput()

    queue <- plot(args$dd1, what = "resources", metric = "usage",
                  "caja del súper", items = "queue", steps = T)
    queue <- queue + xlim(0, args$sim.time)
    queue
  })

  # Tiempo de espera en cola
  output$queue.wait <- renderPlot({
    args <- dataInput()
    queue <- plot(args$dd1, what = "arrivals", metric = "waiting_time")
    queue <- queue + xlim(0, args$sim.time)

    #plot(mm1.env, what = "resources", metric = "usage",
    #     "caja del súper", items = "server", steps = T) +
    #  xlim(0,40)
    queue
  })

}
