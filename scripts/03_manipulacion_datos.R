# -------------------------------------------------------------------------
# Título : Manipulación de datos con tidyverse
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
install.packages(c("tidyverse", "readxl", "writexl", "janitor")) # instalar libreria previamente

# cargar librerias
library(tidyverse)
library(writexl)
library(readxl)
library(janitor)

# limpiar entorno
rm(list = ls()); invisible(gc())

# Resumen y transformación de datos con dplyr -----------------------------

# El paquete `dplyr` : la herramienta principal

# El paquete `dplyr` permite manipular de forma **gramatical o con verbos** una base de datos
# Los verbos de `dplyr` se encadenan a través de un pipe `comando_1() %>% comando_2()`

# | Descripción | Comando |
# | -------------------------------------------------- | ------------ |
# | Selecciona variables a partir de su nombre         | `select()`   |
# | Filtrar filas según condición                      | `filter()`   |
# | Agrega nuevas variables o modifican las existentes | `mutate()`   |
# | Resumen variables                                  | `summarise()`|
# | Hacer operaciones por grupos                       | `group_by()` |
# | Ordenar por variables                              | `arrange()`  |


#  `dplyr` : Selección de variables ---------------------------------------

# Para seleccionar variables usamos `select()`

# importar un archivo delimitado por comas
df_covid <- read_csv("datos/casos_covid-19_bolivar.csv")

# limpiamos los nombres de la base covid
df_covid <- clean_names(df_covid)

# seleccionamos sexo y edad de la base
df_covid_1 <- df_covid %>% 
  select(edad, sexo)

# ver los datos
glimpse(df_covid_1)


# `dplyr` : Selección de variables usando ayudantes -----------------------

# `starts_with()` : Variable que comienzan con un prefijo
# `ends_with()` : Termina con un sufijo
# `contains()` : Contiene una cadena de texto
# `where()` : Seleccionar variables que son de cierto formato

# seleccionar las variables de fecha
df_covid_fechas <- df_covid %>% 
  select(starts_with("fecha"))

glimpse(df_covid_fechas)

# seleccionar variables de número
df_covid_num <- df_covid %>% 
  select(where(is.numeric))

glimpse(df_covid_num)


# `dplyr` : Filtrar valores -----------------------------------------------

# Para filtrar filas o observaciones usamos `filter()` 
# Debemos usar operadores lógicos `==, >, <, >=, <=, &, |, %in%` para filtrar las filas.


# filtrar los casos de Cartagena y sexo masculino
df_covid_ctg_M <- df_covid %>% 
  filter(codigo_divipola_municipio == 13001, sexo == "M")

glimpse(df_covid_ctg_M)

# filtrar ciertos municipios
df_covid_mun <- df_covid %>% 
  filter(
    nombre_municipio %in% c("CARTAGENA", "TURBACO", "ARJONA")
  )

glimpse(df_covid_mun)

# `dplyr` : Resumen de variables ------------------------------------------

# Resumiendo casos con `summarise()` y `count()`

# Numero de casos de COVID
df_covid %>% 
  count()

# Numero de casos de COVID
df_covid %>% 
  summarise(casos = n())

# Numero de casos de COVID por municipio?
df_covid %>% 
  count(by = nombre_municipio)

# Numero de casos de COVID por departamento?
df_covid %>% 
  group_by(nombre_municipio) %>% 
  summarise(caso = n())


# `dplyr` : Crear y transformar variables ---------------------------------

# Usamos el comando `mutate()` para crear y transformar variables 

# cambiar texto a mayusculas
df_covid <- df_covid %>% 
  mutate(
    recuperado = str_to_upper(recuperado)
  )

glimpse(df_covid)

# convertir variable fecha_reporte_web a fecha
df_covid <- df_covid %>% 
  mutate(
    # eliminar la parte del tiempo
    fecha_reporte_web = str_remove(fecha_reporte_web, pattern = " 0:00:00"),
    # pasar a fecha usando el formato dd/mm/YYYY
    fecha_reporte_web = dmy(fecha_reporte_web)
  )

glimpse(df_covid)


# `dplyr` : Transformar o crear variables según condiciones ---------------

# `case_when()` permite evaluar múltiples condiciones y asignar el valor correspondiente dentro de `mutate()`

# Creamos la variable de edad en años
df_covid <- df_covid %>% 
  mutate(
    edad_years = case_when(
      unidad_de_medida_de_edad == 3 ~ edad/365.25, # primera condición
      unidad_de_medida_de_edad == 2 ~ edad/12, # segunda condición
      TRUE ~ edad # cuando no cumplen las condiciones anteriores
    )
  )

# vemos la estructura de los datos con glimpse
glimpse(df_covid)


# `dplyr` : Transformar o crear variables al tiempo -----------------------

# `across()` : nos permite manipular varias variables a la vez.
# Importante! se usa dentro de `mutate()` y `summarise()`
# Con `across()` podemos usar comando de selección como `star_with()` o `where()`

# Estandarizamos las variables de texto a mayusculas
df_covid <- df_covid %>% 
  mutate(
    across(where(is.character), str_to_upper)
  )

glimpse(df_covid)


# Estandarizamos las variables de fecha y texto
df_covid <- df_covid %>% 
  mutate(
    across(
      # variables a aplicar una función
      starts_with("fecha") & where(is.character), 
      # función a aplicar
      ~dmy(str_remove(.x, " 0:00:00"))
    )
  )

glimpse(df_covid)


# Conectando todos los verbos de `dplyr` ----------------------------------

# Podemos encadenar multiples verbos en una sola orden usando `%>%`

# distribución de casos por municipios
df_covid %>% # base de datos
  count(by = nombre_municipio) %>% # contar por grupos
  mutate(prop = n*100/sum(n)) %>%  # calcular la proporcion respecto al total
  arrange(-prop) # ordenar de mayor a menor

# resumen de edad por sexo con casos, promedio, minimo, maximo
df_covid %>% 
  group_by(sexo) %>% 
  summarise(
    casos = n(),
    promedio = mean(edad_years, na.rm = TRUE),
    desv = sd(edad_years, na.rm = TRUE),
    min = min(edad_years, na.rm = TRUE),
    max = max(edad_years, na.rm = TRUE)
  )


# `dplyr` : Cruzar base de datos ------------------------------------------

# `dplyr` cuenta con verbos para cruzar bases de datos
# Supongamos que tenemos una base de datos `df_x` y una `df_y` que tienen un identificador en común: `id`

# base df_x
df_x <- data.frame(
  id =  c(1, 2, 3),
  valor_x = c(12, 34, 45)
)

df_x

# base df_y
df_y <- data.frame(
  id = c(1, 2, 4),
  valor_y = c("A", "B", "C")
)

df_y


# `dplyr` : distintos cruces de base de datos -----------------------------

# `inner_join()` : Adicionar y retiene los indicadores que coinciden entre las bases `df_x`, `df_y`

inner_join(df_x, df_y)

# `left_join()` : Adicionar a la base `df_x` las variables de `df_y` de los indicadores que coinciden

left_join(df_x, df_y)

# `full_join()` : Adicionar y retiene los indicadores que coinciden y los que no entre las bases `df_x`, `df_y`

full_join(df_x, df_y)

# `dplyr` : Uso de `left_join()` en la base de ejemplo --------------------


# casos por municipios
df_casos_mun <- df_covid %>% 
  count(codigo_divipola_municipio, nombre_municipio, name = "casos") 

# muertes por municipios
df_muertes_mun <- df_covid %>% 
  filter(recuperado == "FALLECIDO") %>% 
  count(codigo_divipola_municipio, name = "muertes")

# agregar a la base de casos las muertes
df_casos_muertes_mun <- df_casos_mun %>% 
  left_join(
    df_muertes_mun
  ) %>% 
  arrange(-casos)

# vemos la base de datos
df_casos_muertes_mun

# `tidyr` : Organización de datos -----------------------------------------

# Brinda comandos útiles que permiten transformar las bases de datos (transponer, separa, etc)
# Los verbos más usados son :
#   `pivot_wider()` : transforma una base de formato largo a formato ancho
#   `pivot_longer()` : transforma una base de formato ancho a largo
#   `separate()` : separa en dos columnas valores de texto por un separador

# Usando `pivot_wider()` en la base COVID-19 ------------------------------

# casos por año, mes y municipios
df_covid_year_mes <- df_covid %>% 
  mutate(
    year = year(fecha_de_notificacion),
    mes = month(fecha_de_notificacion)
  ) %>% 
  select(id_de_caso, nombre_municipio, year, mes)

# resumimos los datos
df_casos_mes <- df_covid_year_mes %>%  
  count(nombre_municipio, year, mes, name = "casos")

# vemos los datos 
df_casos_mes

# pasar los años de las filas a variable
df_casos_mes_wide <- df_casos_mes %>% 
  arrange(nombre_municipio, mes) %>% # ordenar los datos por mes
  pivot_wider(names_from = mes, # valores que serán columnas
              values_from = casos, # valores a trasponer
              names_prefix = "mes_", # prefijo de los nombres 
              values_fill = 0) # si no hay valores coloca un 0

# vemos los datos
df_casos_mes_wide


# Usando `pivot_longer()` en la base COVID-19 -----------------------------

# definimos las colunmnas a pasar a formato largo y valores 
df_casos_mes_long <- df_casos_mes_wide %>% 
  pivot_longer(cols = mes_1:mes_12, # variables a transponer
               names_to = "mes", # nueva variable
               values_to = "casos") # valores

# vemos los datos
df_casos_mes_long

