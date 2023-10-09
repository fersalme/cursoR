# -------------------------------------------------------------------------
# Título : Importar bases de datos en R
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : ALZAK Foundation
# Correo : fsalcedo@alzakfoundation.org
# Fecha de creación : 2023-08-26
# Licencia : MIT-Copyright (c) 2023 Fernando Salcedo Mejía
# -------------------------------------------------------------------------
# Notas : ver presentación 03_importar_manipular_datos.html
# -------------------------------------------------------------------------

# Paquetes necesarios -----------------------------------------------------
# instalar paquetes
install.packages(c("tidyverse", "readxl", "janitor")) # instalar libreria previamente

# limpiar entorno
rm(list = ls()); invisible(gc())

# Importar un archivo plano con readr -------------------------------------

# El paquete `readr`

# El paquete `readr` permite leer archivos planos
# También ajusta el formato adecuado para cargarlo en R

# ¿Qué es un archivo plano?

# Es un tipo de archivo de almacenamiento de datos en **texto sin formato** usando una estructura tabular con filas y columnas. Usualmente se llaman `file.csv` o `file.txt` y son de tres tipos:

# Valores separados por comas
# Valores separados por punto y coma
# Valores separados por tabuladores

# | Tipo de archivo                    | Comando        |
# |------------------------------------|----------------|
# | Valores separados por comas        | `read_csv()`   |
# | Valores separados por punto y coma | `read_csv2()`  |
# | Valores separados por tabuladores  | `read_delim()` |

# cargar librerias
library(tidyverse)

# importar un archivo delimitado por comas
df_covid <- read_csv("../datos/casos_covid-19_bolivar.csv")

# ver los datos en la consola
glimpse(df_covid)

# Importar datos desde Excel con readxl -----------------------------------

# El paquete `readxl` permite leer datos desde archivos de Excel
# Para instalarlo usamos `install.packages("readxl)` y `library(readxl)`

# | Uso                       | Comando                                           |
# |---------------------------|-------------------------------------------------- |
# | Número de hojas y nombres | `excel_sheets(path = "file.xlsx")`                |
# | Leer datos de una hoja    | `read_excel(path = "file.xlsx", sheet = "hoja1")` |
  
# Si el archivo de Excel solo contiene una sola hoja con datos, no es necesario usar la opción `sheet`

# cargar la libreria
library(readxl)

# nombres hojas
excel_sheets(path = "datos/casos_covid-19_bolivar.xlsx")

# importar los datos
df_covid <- read_excel(path = "datos/casos_covid-19_bolivar.xlsx", # archivo de Excel
                       sheet = "Sheet1" ) # hoja con los datos

# ver los datos en la consola
glimpse(df_covid)

# El paquete utilitario janitor -------------------------------------------

# `janitor` es un paquete utilitario de limpieza de datos. 
#  El comando `clean_names()` nos sirve para limpiar nombres en bases de datos.

# cargamos la libreria
library(janitor)

# nombres de la variables
names(df_covid)

# limpiamos los nombres de la base covid
df_covid <- clean_names(df_covid)
names(df_covid)
