# ----------------------------------------------------
# Título : Manipulación de datos con tidyverse
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : Economista
# Fecha de creación : 2023-08-26
# ----------------------------------------------------
# Notas : 
# ----------------------------------------------------

# limpiar entorno
rm(list = ls())


# Importar datos con readr ------------------------------------------------

# cargamos tidyverse
install.packages("tidyverse")
library(tidyverse)

# cargar datos desde un archivo plano
# verificar el tipo de delimitador del archivo plano
readLines(con = "datos/casos_covid-19_bolivar.csv", n = 10)

df_covid <- read_csv(file = "datos/casos_covid-19_bolivar.csv")

# ver los datos compacta
glimpse(df_covid)

# Instalar janitor para limpiar nombres
install.packages("janitor")
library(janitor)

# nombres actuales datos
names(df_covid)
# limpiar nombres
df_covid <- clean_names(df_covid)
# ver los cambios
names(df_covid)


# Importar desde Excel ----------------------------------------------------
# instalar paquete
install.packages("readxl")
library(readxl)

# ver nombres de las hojas de excel
excel_sheets(path = "datos/casos_covid-19_bolivar.xlsx")

# importar datos
df_covid <- read_excel(path = "datos/casos_covid-19_bolivar.xlsx", 
                       sheet = "Sheet1")

# limpiar los nombres
df_covid <- clean_names(df_covid)

# ver datos
glimpse(df_covid)


# Manipulacion con dplyr --------------------------------------------------

df_covid_personas <- df_covid %>% # Crtl + shift + M %>% 
  select(id_de_caso, sexo, edad)

glimpse(df_covid_personas)

df_covid_personas <- df_covid %>% 
  select(id = id_de_caso, sexo, edad)

glimpse(df_covid_personas)

# seleccionar con ayudates tidyselect
# seleccionar todas las variables que comienzan con la palabra fecha
df_covid_fecha <- df_covid %>% 
  select(starts_with("fecha"))

glimpse(df_covid_fecha)

# seleccionar variables tipo numeric
df_covid_num <- df_covid %>% 
  select(where(is.numeric))

glimpse(df_covid_num)

# Filtrar valores
df_covid_turbaco <- df_covid %>% 
  filter(codigo_divipola_municipio == 13836, sexo == "F")

glimpse(df_covid_turbaco)

df_covid_ctg_turbaco <- df_covid %>% 
  filter(codigo_divipola_municipio == 13001 | codigo_divipola_municipio == 13836)

glimpse(df_covid_ctg_turbaco)

df_covid_ctg_turb_arj <- df_covid %>% 
  filter(
    nombre_municipio %in% c("CARTAGENA", "TURBACO", "ARJONA")
  )

glimpse(df_covid_ctg_turb_arj)

# Resumir datos

# total de casos
df_covid %>% count()

# total de casos por municipios
df_casos_municipio <- df_covid %>% 
  count(nombre_municipio)

# total de casos por municipio (usando summarise)
df_casos_municipio <- df_covid %>% 
  group_by(nombre_municipio) %>% 
  summarise(casos = n())

# Trasformar los datos con mutate
df_covid_mayus <- df_covid %>% 
  mutate(
    recuperado = str_to_upper(recuperado)
  )

# calcular valores
df_reporte_recuperado <- df_covid %>% 
  mutate(
    recuperado = str_to_upper(recuperado)
  ) %>% 
  count(recuperado)

df_reporte_recuperado <- df_reporte_recuperado %>% 
  mutate(
    prop = (n/sum(n)) * 100
  )

df_reporte_recuperado
