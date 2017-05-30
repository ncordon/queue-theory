#!/usr/bin/env Rscript
# Script de instalación local de la práctica


### Paquetes a instalar
pkgs = c('simmer', 'simmer.plot', 'ggplot2', 'shiny', 'shinythemes', 'mgcv')

cat("###################################################################\n")
cat("Instalando paquetes necesarios\n")
cat("###################################################################\n")

load.my.packages <- function(){
  to.install <- pkgs[ ! pkgs %in% installed.packages() ]

  if ( length(to.install) > 0 )
    install.packages( to.install, dependencies = TRUE, repos = "http://cran.r-project.org" )

  sapply(pkgs, require, character.only=TRUE)
}

cat("###################################################################\n")
cat("Cargando paquetes\n")
cat("###################################################################\n")

load.my.packages()


cat("###################################################################\n")
cat("Aplicación en localhost...\n")
cat("###################################################################\n")

runApp(port = 8765)
