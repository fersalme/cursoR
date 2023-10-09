# ----------------------------------------------------
# Título : Manipulación de datos con tidyverse
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : Economista
# Fecha de creación : 2023-08-26
# ----------------------------------------------------
# Notas : 
# ----------------------------------------------------

# limpiar entorno
rm(list = ls()); invisible(gc())


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

# ajustes de fechas 
df_covid <- df_covid %>% 
  mutate(
    # eliminar el tiempo en las fechas 
    fecha_reporte_web = str_remove(fecha_reporte_web, " 0:00:00"),
    # convertir fecha de texto en fecha formato Date
    fecha_reporte_web = dmy(fecha_reporte_web)
  )

# Trasformar varias variables a la vez
df_covid <- df_covid %>% 
  mutate(
    # seleccionar las variables que comiencen con fecha y sean de 
    # formato texto
    across(starts_with("fecha") & where(is.character),
           ~dmy(str_remove(.x, " 0:00:00")))
  )

# pasar texto a mayusculas
df_covid <- df_covid %>% 
  mutate(
    across(where(is.character), str_to_upper)
  )

# crear o modificar una variable según condición
df_covid <- df_covid %>% 
  mutate(
    # crear una variable nueva edad en años
    # nota : 1 edad en años, 2 edad en meses y 3 edad en días
    edad_años = case_when(
      unidad_de_medida_de_edad == 3 ~ edad/365,
      unidad_de_medida_de_edad == 2 ~ edad/12,
      unidad_de_medida_de_edad == 1 ~ edad # forma explicita
      # TRUE ~ edad # por exclusion
    )
  )

# conectar comandos de forma secuencial
df_reporte_casos <- df_covid %>% 
  # 1. filtrar los casos notificados entren 01/03/2020 hasta 31/12/2020
  filter(
    fecha_de_notificacion >= dmy("01/03/2020"),
    fecha_de_notificacion <= dmy("31/12/2020")
  ) %>% 
  # 2. contar el numeros de casos por nunicipios
  count(nombre_municipio, name = "casos") %>% 
  # 3. calcular la proporcion de casos entre los municipios
  mutate(
    prop_casos = casos/sum(casos)
  ) %>% 
  # 4. ordenar de mas casos a menos casos
  arrange(desc(casos))

# Cruzar bases de datos
# base df_x
df_x <- data.frame(
  id =  c(1, 2, 3),
  valor_x = c(12, 34, 45)
)
# base df_y
df_y <- data.frame(
  id = c(1, 2, 4),
  valor_y = c("A", "B", "C")
)

# Cruzar las bases y se quede lo que coincide
inner_join(df_x, df_y)

# Cruzar las bases y se adicione lo que coincide a una base principal
left_join(df_x, df_y)

# Cruzar las bases sin eliminar lo que no coincide
full_join(df_x, df_y)

# Crear una base de casos totales y de muertes por municipios
# Paso 1. Crear una base con el total de casos por divipola y municipios

df_casos_municipio <- df_covid %>% 
  count(codigo_divipola_municipio, nombre_municipio, name = "casos")

# Paso 2. Recuento de muertes por divipola y municipios
df_muertes_municipio <- df_covid %>% 
  filter(
    !is.na(fecha_de_muerte)
  ) %>% 
  count(codigo_divipola_municipio, nombre_municipio, name = "fallecidos")
  
# Paso 3. Cruzar los datos
df_reporte_covid <- df_casos_municipio %>% 
  left_join(
    df_muertes_municipio
  )

# Ejercicio 1. 
# Calcular la proporción de muertes por muncipios respecto a los casos 
# totales de cada municipio
# ¿Cual municipio tiene la mayor proporción de fallecidos por COVID?


# Manipulacion con tidyr --------------------------------------------------

# trasponer una base de formato largo a ancho
df_trasponer <- data.frame(
  id = c(1, 1, 2),
  med = c("A", "B", "C"),
  mes = c(1, 2, 1)
)
df_trasponer_ancho <- df_trasponer %>% 
  pivot_wider(names_from = mes, values_from = med,
              names_prefix = "mes_")
df_trasponer_ancho

df_trasponer_largo <- df_trasponer_ancho %>% 
  pivot_longer(cols = mes_1:mes_2, names_to = "mes", values_to = "med")
df_trasponer_largo

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
  
# trasponer los meses y casos
df_casos_municipio_ancho <- df_casos_municipio %>% 
  # ordenar por municipio y mes
  arrange(nombre_municipio, mes) %>% 
  # trasponer a formato ancho
  pivot_wider(names_from = mes, values_from = casos, 
              names_prefix = "mes_", 
              values_fill = 0)

# trasponer a lo largo
df_casos_municipio_largo <- df_casos_municipio_ancho %>% 
  pivot_longer(cols = mes_1:mes_12, names_to = "mes", values_to = "casos")

# limpiar el mes de la base a largo
df_casos_municipio_largo <- df_casos_municipio_largo %>% 
  mutate(
    # eliminar el texto mes_
    mes = str_remove(mes, "mes_"),
    # pasar de texto a numero
    mes = as.numeric(mes)
  )

# separar en columnas valores
# primero pegamos el divipola y el nombre del municipio como ejemplo
df_covid <- df_covid %>% 
  mutate(
    divipola_municipio = paste0(codigo_divipola_municipio, "-", nombre_municipio)
  )

df_covid <- df_covid %>% 
  separate(col = divipola_municipio, 
           into = c("cod_divipola", "nom_mun"), 
           sep = "-",
           remove = FALSE)


# pegar verticalmente dos o mas bases de datos
df_covid_ctg_2020 <- df_covid %>% 
  filter(
    year(fecha_de_notificacion) == 2020, 
    cod_divipola == "13001"
  )

df_covid_turb_2020 <- df_covid %>% 
  filter(
    year(fecha_de_notificacion) == 2020,
    cod_divipola == "13836"
  )

# pegar verticalmente los datos
df_covid_2020 <- bind_rows(df_covid_ctg_2020, df_covid_turb_2020)

# Exportar datos a Excel --------------------------------------------------
install.packages("writexl")
library(writexl)

# exportar una base de datos a una hoja de excel
write_xlsx(df_casos_municipio, path = "datos/base_casos_municipio.xlsx")

# dividir la base por años
list_casos_municipio <- df_casos_municipio %>% 
  split(.$año)

# exportar la base de datos a excel pero cada hoja es un año de reporte
write_xlsx(list_casos_municipio, path = "datos/base_casos_municipio_años.xlsx")
