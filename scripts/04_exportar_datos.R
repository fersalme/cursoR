# -------------------------------------------------------------------------
# Título : Exportar datos en R
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : ALZAK Foundation
# Correo : fsalcedo@alzakfoundation.org
# Fecha de creación : 2023-10-09
# Licencia : MIT-Copyright (c) 2023 Fernando Salcedo Mejía
# -------------------------------------------------------------------------
# Notas : 
# -------------------------------------------------------------------------

# Paquetes necesarios -----------------------------------------------------
# instalar paquetes
install.packages(c("tidyverse", "readxl", "writexl", "janitor")) # instalar libreria previamente

# cargar librerias
library(tidyverse)
library(writexl)
library(janitor)

# limpiar entorno
rm(list = ls()); invisible(gc())

# Importar base de datos COVID-19 Bolívar ---------------------------------

# importar un archivo delimitado por comas
df_covid <- read_csv("datos/casos_covid-19_bolivar.csv")

# limpiamos los nombres de la base covid
df_covid <- clean_names(df_covid)

# Reporte de casos por municipio, mes y año
df_casos_municipio <- df_covid %>% 
  # crear las variables año y mes
  mutate(
    # varible año
    año = year(fecha_de_notificacion),
    mes = month(fecha_de_notificacion)
  ) %>% 
  count(codigo_divipola_municipio, nombre_municipio,
        año, mes, name = "casos")

# muertes por municipios, mes y año
df_muertes_municipio <- df_covid %>% 
  filter(recuperado == "FALLECIDO") %>% 
  # crear las variables año y mes
  mutate(
    # varible año
    año = year(fecha_de_notificacion),
    mes = month(fecha_de_notificacion)
  ) %>% 
  count(codigo_divipola_municipio, nombre_municipio,
        año, mes, name = "casos")

# Exportar a archivo plano ------------------------------------------------

# Si queremos que el archivo se pueda leer desde cualquier programa usamos `write_csv()`
# Ventajas : Se puede usar en otros programas
# Desventajas : El archivo es más pesado y perdemos los formatos de los datos como las fechas

# guardar los datos
write_csv(df_casos_municipio, file = "resultados/casos_municipios_bolivar.csv")

# Exportar a Excel --------------------------------------------------------

# Para exportar usamos el paquete `writexl`
# Su función principal es `write_xlsx()` que permite exportar bases de datos a archivos de Excel.

# Importate! :
# Tenga en cuenta Excel no puede guardar más de 1 millón de filas por hoja

# guardar una base
write_xlsx(df_muertes_municipio, path = "resultados/muertes_municipios_bolivar.xlsx")

# guardar múltiples hojas
list_hojas <- list(
  casos_municipios = df_casos_municipio,
  muertes_municipios = df_muertes_municipio
)

# guardar todo
write_xlsx(list_hojas, path = "resultados/covid_bolivar.xlsx")


# Separar por grupos una base ---------------------------------------------

# Usando el comando `split()` puedes crear una lista de bases de datos por grupos.
# Es útil para exportar datos a Excel donde cada base sea una hoja por separado.

# dividir la base por años
list_casos_municipio <- df_casos_municipio %>% 
  split(.$año)

# exportar la base de datos a excel pero cada hoja es un año de reporte
write_xlsx(list_casos_municipio, path = "resultados/base_casos_municipio_años.xlsx")

# Guardar en formato `R` --------------------------------------------------

# Para guardar cualquier objeto en formato `R` usamos `saveRDS()`
# También podemos guardar multiplex objetos usando `save()`
# Ventajas : El archivo conserva el formato de `R`, es más liviano y más rápido leerlo
# Desventajas : Es exclusivo de `R`

# guardar en formato Rds
saveRDS(df_casos_municipio, file = "resultados/base_covid_bolivar.rds")

# guardar en RData
save(df_casos_municipio, df_muertes_municipio, file = "resultados/bases_covid_bolivar.RData")

