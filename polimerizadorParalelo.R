#' This package performs the computational polymerization of linear molecules from their structural repetitive units by using Simplified Molecular Input Line Entry Specification (SMILES).
#'
#' @param SMILES_SRU The Structural Repetitive Unit expresed by SMILES code. It must contain two asterisks (*), one indicating the head and the other indicating the tail.
#' @param PD Polymerization Degree.
#' @return The SMILES representation of the resulting polymer with the desired polymerization degree.
#' @examples
#' PolyMaS("*C(C*)c1ccccc1",19)
#' @export
#' @import foreach
#' @import doParallel
PolyMaS<-function(SMILES_SRU, PD){
  library(foreach)
  library(doParallel)

  cores=max(1, detectCores(logical = TRUE)-1)
  cl <- makeCluster(cores)
  registerDoParallel(cl)


  cantidadDivisiones<-ceiling(PD*0.003)
  PDEntero<-PD%/%cantidadDivisiones
  PDResto<-PD%%cantidadDivisiones
  cantidadPD<-array(data=PDEntero,dim=cantidadDivisiones)
  for(i in 1:cantidadDivisiones){
    if(PDResto>0){
      cantidadPD[i]=PDEntero+1
      PDResto<-PDResto-1
    }
  }

    #polimerizar en paralelo dividiendo por cant de cores
    polimeros<-foreach(i=1:cantidadDivisiones, .combine='rbind', .export = 'algoritmoPolimerizacion') %dopar% {
      if(cantidadPD[i]>0)
        algoritmoPolimerizacion(SMILES_SRU, cantidadPD[i])
    }

    #el objetivo es obtener una unica cadena representando el polimero completo
    while(length(polimeros)>1){
      #tomo cada uno de los n=cores polimeros y realizo la union en paralelo de a dos polimeros
      polimerosCoresParseados<-foreach(i=seq(from=1, to=length(polimeros), by=2), .combine='rbind', .export = 'unionDosPolimerosEnUno') %dopar% {
        unionDosPolimerosEnUno(polimeros[i], polimeros[i+1])
      }
      polimeros<-polimerosCoresParseados
    }

    polimero<-polimeros
    stopCluster(cl)
    return(polimero)
}



algoritmoPolimerizacion <-function(SMILES_SRU, n){
  if(n>1){
    # se inicializa la variable que contendr? el SMILES resultante
    # se reemplaza el primer * de la SMILES_SRU por ??? quedando un *
    # restante y se asigna el resultado a la variable smilesGenerado
    smilesGenerado<- sub("*","?", SMILES_SRU, fixed=TRUE)

    # se elimina el primer * de la cadena original reemplaz?ndolo por
    # cadena vac?a ?? y se asigna el resultado en la variable URSinAsterisco
    URSinAsterisco<-sub("*","", SMILES_SRU, fixed=TRUE)

    for(i in 1:(n-1)){
      # se reemplaza el ?nico ?*? presente en ?smilesGenerado? por la cadena
      # de caracteres almacenada por URSinAsterisco y se asigna el resultado
      # en ?smilesGenerado?
      smilesGenerado<-gsub("*",URSinAsterisco,smilesGenerado, fixed=TRUE)
    }

    # se reemplaza el ??? por un ?*?, de esta forma la cadena resultante
    # quedar? con un ?*? para la cabeza y un ?*? para la cola
    smilesGenerado<-sub("?","*",smilesGenerado, fixed=TRUE)

  }
  else{
    smilesGenerado<-SMILES_SRU
  }

  return(smilesGenerado)
}

unionDosPolimerosEnUno<-function(polimero1, polimero2){
  union<-polimero1
  if(!is.na(polimero2)){
    smilesGenerado<- sub("*","?", polimero1, fixed=TRUE)
    URSinAsterisco<-sub("*","", polimero2, fixed=TRUE)
    smilesGenerado<-gsub("*",URSinAsterisco,smilesGenerado, fixed=TRUE)
    smilesGenerado<-sub("?","*",smilesGenerado, fixed=TRUE)
    union<-smilesGenerado
  }
  return(union)
}
