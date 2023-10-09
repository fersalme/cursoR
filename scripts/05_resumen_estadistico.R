# -------------------------------------------------------------------------
# Título : 
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : ALZAK Foundation
# Correo : fsalcedo@alzakfoundation.org
# Fecha de creación : 2023-10-09
# Licencia : MIT-Copyright (c) 2023 Fernando Salcedo Mejía
# -------------------------------------------------------------------------
# Notas : ver presentación 04_resumen_estadistico.html
# -------------------------------------------------------------------------

# Paquetes necesarios -----------------------------------------------------
# instalar paquetes
install.packages(c("tidyverse", "janitor")) # instalar libreria previamente

# cargar librerias
library(tidyverse)
library(janitor)

# limpiar entorno
rm(list = ls()); invisible(gc())


# Datos de análisis -------------------------------------------------------

# Usaremos una base de dispensación de medicamentos.

df_med <- read_csv2("../datos/base_medicamentos.csv")

# Limpiar nombres
df_med <- clean_names(df_med)
# encabezado
glimpse(df_med)


# Tablas de frecuencia absoluta -------------------------------------------

# El comando `table()` permite resumir una variable **categórica** en frecuencias absolutas.
# Las frecuencias absolutas no es más que el recuento de veces que aparece un valor dentro de una variable.

# tabla de frecuencia
table(df_med$tipo_entrega)

# tabla de frecuencia ordenada
sort(table(df_med$tipo_entrega))

# tabla de frecuencia incluyendo valores NA
table(df_med$tipo_entrega, exclude = NULL)

# Tablas de frecuencia relativa -------------------------------------------

# Usamos el comando `prop.table()` para calcular las frecuencias relativas o porcentajes de una categoría dentro de una variable.

# proprocion de tipo de entrega sobre el total
prop.table(table(df_med$tipo_entrega))

# en terminos porcentuales
prop.table(table(df_med$tipo_entrega)) * 100

# Tabla de frecuencia cruzada ---------------------------------------------

# Tabla de frecuencia donde se reportan las frecuencias conjuntas de dos variables.

# tipo de entega (filas) y pbs (columnas)
table(df_med$tipo_entrega, df_med$pbs)

# si queremos ver el nombre de cada variables
with(df_med, table(tipo_entrega, pbs))

# agregar el total fila y columna
addmargins(with(df_med, table(tipo_entrega, pbs)))


# Tabla de frecuencia cruzada relativa ------------------------------------

# En este caso, la tabla de frecuencia relativa se calcula respecto a : 
# Total fila `prop.table(tab, margin = 1)`
# Total columna `prop.table(tab, margin = 2)`
# Total general (valor predeterminado) `prop.table(tab, margin = 3)`

# porcentaje de medicamentos por pbs según tipo de entrega
tab <- with(df_med, table(tipo_entrega, pbs))
prop.table(tab, margin = 1) * 100

# porcentaje de medicamentos por tipo de entrega según pbs
prop.table(tab, margin = 2) * 100

# porcentaje de medicamentos pbs y tipo de entrega
prop.table(tab) * 100


# Resumen de una variable continua ----------------------------------------

# Las variables continuas son las variables que solo numéricas que están comprendidas en un rango.

# `summary()` : resumen estadístico de `r-base`
# Las funciones de resumen estadístico típico con `R` son :
# `mean()` : calcula la media
# `sd()` : calcula la desviación estándar
# `var()` : calcula la varianza
# `min()` : valor mínimo
# `max()` : valor máximo
# `median()` : calcula la mediana
# `length()` : largo o número de valores
# `range()` : calcula el valor mínimo y máximo
# `quantile()` : calcula los percentiles de un vector numérico`

# Las funciones de resumen estadístico son sensibles a los valores `NA` devolviendo `NA` 
# si hay alguno presente. Use `na.rm = TRUE`

# resumen de las variables
vars_num <- sapply(df_med, class)
summary(df_med[vars_num == "numeric"])

# resumen de la media en todas las variables numéricas con dplyr
df_med_media <- df_med %>% 
  select(-id) %>% 
  summarise(
    across(where(is.numeric), list(mean = mean, sd = sd))
  )

df_med_media


# Estratificar resumen estadístico ----------------------------------------

# Podemos realizar el resumen estadístico por grupos usando `by()`

# resumen de las variables por grupos
with(df_med, by(data = precio, INDICES =  pbs, FUN = summary))

# Categorizar una variable numérica ---------------------------------------

# Debemos definir puntos de corte y contar los valores en cada cohorte.
# Por ejemplo, precios por encima del promedio o usando cuartiles.

# precio promedio
mean_precio <- mean(df_med$precio, na.rm = TRUE)

# medicamentos por encima y debajo del promedio
table(df_med$precio > mean_precio)

# usando cuartiles
cuartil_precio <- quantile(df_med$precio, c(0, 0.25, 0.5, 0.75, 1))
cuartil_precio
q_precio <- cut(df_med$precio, breaks = cuartil_precio,
                include.lowest = TRUE, right = FALSE)
table(q_precio)

# usando dplyr
df_med %>% 
  group_by(familia) %>% 
  summarise(
    promedio = mean(costo_total, na.rm = TRUE),
    min = min(costo_total, na.rm = TRUE),
    max = max(costo_total, na.rm = TRUE)
  )

