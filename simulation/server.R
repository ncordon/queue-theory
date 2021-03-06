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
library('mgcv')



##########################################################################
# Resultados
##########################################################################
function(input, output){
  dd1Input <- reactive({
    sim.time <- input$sim.dd1.time
    inter.arrival <- input$arrival.dd1
    inter.service <- input$service.dd1

    # Parametros no vacios y no nulos
    req(inter.arrival > 0)
    req(inter.service > 0)

    dd1.trajectory <- trajectory() %>%
      seize("donación de sangre", amount=1) %>%
      timeout(function(){ inter.service }) %>%
      release("donación de sangre", amount=1)


    dd1.env <- simmer() %>%
      add_resource("donación de sangre", capacity=1, queue_size=Inf) %>%
      add_generator("llegadas", dd1.trajectory, function(){ inter.arrival })


    dd1.env %>% run(until=sim.time)

    list(dd1 = dd1.env, sim.time = sim.time)
  })



  mm1Input <- reactive({
    seed <- input$mm1.seed
    req(seed > 0)
    set.seed(seed)

    sim.time <- input$sim.mm1.time
    lambda <- input$arrival.mm1.freq
    mu <- input$service.mm1.freq

    # Parametros no vacios y no nulos
    req(lambda > 0)
    req(mu > 0)

    mm1.trajectory <- trajectory() %>%
      seize("caja del súper", amount=1) %>%
      timeout(function(){ rexp(1, mu) }) %>%
      release("caja del súper", amount=1)


    mm1.env <- simmer() %>%
      add_resource("caja del súper", capacity=1, queue_size=Inf) %>%
      add_generator("llegadas", mm1.trajectory, function(){ rexp(1, lambda) })


    mm1.env %>% run(until=sim.time)

    list(mm1 = mm1.env, sim.time = sim.time)
  })





  ############################################################
  # Cola D/D/1
  ############################################################
  # Media de clientes en el sistema
  output$dd1.queue.server.usage <- renderPlot({
    args <- dd1Input()
    server <- plot(args$dd1, what = "resources", metric = "usage",
                   "donación de sangre", items=c("queue", "server"), steps = T)
    server <- server + xlim(0, args$sim.time)
    server
  })

  output$dd1.system.usage <- renderPlot({
    args <- dd1Input()
    server <- plot(args$dd1, what = "resources", metric = "usage",
                   "donación de sangre", items=c("system"), steps = T)
    server <- server + xlim(0, args$sim.time)
    server
  })

  # Tiempo de espera en cola
  output$dd1.queue.wait <- renderPlot({
    args <- dd1Input()
    queue <- plot(args$dd1, what = "arrivals", metric = "waiting_time")
    queue <- queue + xlim(0, args$sim.time)

    queue
  })

  ############################################################
  # Cola M/M/1
  ############################################################
  # Media de clientes en el sistema
  output$mm1.system.usage <- renderPlot({
    args <- mm1Input()
    server <- plot(args$mm1, what = "resources", metric = "usage",
                   names = "caja del súper", items=c("queue", "server", "system"))
    server <- server + xlim(0, args$sim.time)
    server
  })


  # Tiempo de espera en cola
  output$mm1.queue.wait <- renderPlot({
    args <- mm1Input()
    queue <- plot(args$mm1, what = "arrivals", metric = "waiting_time")
    queue <- queue + xlim(0, args$sim.time)

    queue
  })
}
