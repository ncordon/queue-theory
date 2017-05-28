#!/usr/bin/Rscript

# Limpieza del entorno
rm(list = ls())


##########################################################################
# Lista de paquetes a cargar
##########################################################################

pkgs <- c('simmer','ggplot2', 'simmer.plot')

set.seed(123456)
options(digits=22)

load.my.packages <- function(){
  to.install <- pkgs[ ! pkgs %in% installed.packages()[,1] ]

  if ( length(to.install) > 0 ){
    install.packages( to.install, dependencies = TRUE )
  }

  sapply(pkgs, require, character.only=TRUE)
}

load.my.packages()

lambda <- 3
mu <- 4
rho <- lambda/mu # = 2/4


mm1.trajectory <- trajectory() %>%
  seize("cajerx", amount=1) %>%
  timeout(function(){ mu }) %>%
  release("cajerx", amount=1)


mm1.env <- simmer() %>%
  add_resource("cajerx", capacity=1, queue_size=Inf) %>%
  add_generator("cola del súper", mm1.trajectory, function(){ lambda })


mm1.env %>% run(until=40)


plot(mm1.env, what = "resources", metric = "usage",
     "cajerx", items = "queue", steps = T) +
  xlim(0,40)

plot(mm1.env, what = "resources", metric = "usage",
     "cajerx", items = "server", steps = T) +
  xlim(0,40)
