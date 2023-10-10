# -------------------------------------------------------------------------
# Título : Creación de gráficos con R
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : ALZAK Foundation
# Correo : fsalcedo@alzakfoundation.org
# Fecha de creación : 2023-10-09
# Licencia : MIT-Copyright (c) 2023 Fernando Salcedo Mejía
# -------------------------------------------------------------------------
# Notas : ver presentación 05_resumen_graficos_datos.html
# -------------------------------------------------------------------------

# Paquetes necesarios -----------------------------------------------------
# instalar paquetes
install.packages(c("tidyverse", "janitor")) # instalar libreria previamente

# cargar librerias
library(tidyverse)
library(janitor)

# limpiar entorno
rm(list = ls()); invisible(gc())


# Carga datos -------------------------------------------------------------

# Usaremos una base de dispensación de medicamentos.

# Cargamos los datos de ejemplo
library(tidyverse)
df_med <- read_csv2("datos/base_medicamentos.csv")

# Limpiar nombres
df_med <- janitor::clean_names(df_med)

# usamos datos completos
df_med <- df_med %>% 
  drop_na()

# encabezado
glimpse(df_med)


# Gráficos exploratorios con `R-base` -------------------------------------

# Histograma
# Los histogramas muestran la distribución de una variable continua dividiendo sus valores en rangos y 
# representando la frecuencia de valores que están en esos rangos.

hist(df_med$precio, 
     xlab = "Precio medicamentos", 
     ylab = "Frecuencia", 
     main = "Histrograma precio")

# Densidad

# Un gráfico de densidad técnicamente es la estimación de la función de densidad de probabilidad de una variable aleatoria. 
# Los diagramas de densidad pueden ser una forma efectiva de ver la distribución de una variable continua. 

plot(density(df_med$precio), #vector o variable
     xlab = "Precio medicamentos", 
     ylab = "Frecuencia", 
     main = "Histrograma precios")

# Caja y bigotes

# Describe una variable continua en cinco estadísticos de resumen : 
# mínimo, primer cuartil (25%), mediana (50%), tercer cuartil (75%) y máximo
# También permite identificar valore extremos

# una variable
boxplot(df_med$costo_total)

# una variable sin datos atipicos
boxplot(df_med$costo_total, outline = FALSE)

# dos o más variables categóricas o factor
boxplot(costo_total ~ pbs, data = df_med, outline = FALSE)

# Gráficos de barras simple

# Gráficos de barras (simples y apiladas)
# Las gráficas de barras representan un volumen o cantidad de un atributo. 
# Por ejemplo, número de dispensaciones realizadas o promedio del costo de un medicamento por mes.
# Son el tipo de gráfico más usados.

barplot(table(df_med$pbs), 
        xlab = "PBS",
        ylab = "Frecuencia", 
        main = "Dispensaciones por plan de beneficios")

# mas de un grupo no apilado
tab <- table(df_med$tipo_entrega, df_med$pbs)
barplot(tab, 
        beside = TRUE,
        legend.text = rownames(tab),
        args.legend = list(x = "topleft"),
        xlab = "PBS",
        ylab = "Frecuencia", 
        main = "Dispensaciones por plan de beneficios")

# mas de un grupo apilado
barplot(tab,
        legend.text = rownames(tab),
        args.legend = list(x = "topleft"),
        xlab = "PBS",
        ylab = "Frecuencia", 
        main = "Dispensaciones por plan de beneficios")

# mas de un grupo apilado 100%
barplot(prop.table(tab, 2)*100,
        legend.text = rownames(tab),
        args.legend = list(x = "topleft"),
        xlab = "PBS",
        ylab = "Frecuencia", 
        main = "Dispensaciones por plan de beneficios")


# Gráficos con `ggplot2` --------------------------------------------------

# Gráfico de barras `geom_col()` y `geom_bar()` ---------------------------

# Lo usamos para representar volúmenes o cantidad
# Realicemos un gráfico con `geom_bar()` siguiendo el esquema paso a paso de cómo funciona `ggplot()`, 

# libreria ggplor2 hace parte de tidyverse
library(ggplot2)

ggplot(data = df_med, mapping = aes(x = pbs)) + # Paso 1 : Define tus variables (mapping)
  geom_bar() + # Paso 2 : Define el tipo de gráfico (geom)
  labs(x = "PBS", # Paso 3 : Define etiquetas para ejes y titulos
       y = "Frecuencia",
       title = "Dispensaciones de medicamentos por plan de beneficios") +
  theme_minimal() # Paso 4 opcional : definir un tema


# Usando `fill` para agregar grupos en `geom_bar()` -----------------------

# Usamos la opción `fill` para señalar usando colores grupos en el gráficos de barras.

ggplot(df_med, aes(x = pbs, fill = tipo_entrega)) + # Usamos fill para agregar grupos
  geom_bar() +
  labs(x = "PBS",
       y = "Frecuencia",
       title = "Dispensaciones medicamentos por plan de beneficios",
       fill = "Tipo de entrega") +
  theme_bw()


# Usando `fill` para grupos no apilados en `geom_bar()` -------------------
# Usando la opción `dodge` en `geom_bar()`

# mas de un grupo apilado 
ggplot(data = na.omit(df_med),
       mapping = aes(x = pbs, fill = tipo_entrega)) +
  geom_bar(position = "dodge") +
  labs(x = "PBS",
       y = "Frecuencia",
       title = "Dispensaciones por plan de beneficios",
       fill = "Tipo de entrega") +
  theme_bw()

# Apilar los grupos al 100% con `geom_bar()` ------------------------------

# Para ello, usamos la opción `fill` dentro de `geom_bar()`

# mas de un grupo apilado 100%
ggplot(df_med, aes(x = pbs, fill = tipo_entrega)) +
  geom_bar(position = "fill") +
  labs(x = "PBS",
       y = "Frecuencia",
       title = "Dispensaciones por plan de beneficios", 
       fill = "Tipo de entrega") + 
  theme_bw()


# Etiquetas de datos con `geom_text()` ------------------------------------

# `geom_text()` permite agregar etiquetas de datos a las gráficas

# definir los datos y las graficar 
ggplot(data = df_med, mapping = aes(x = pbs)) +
  geom_bar() +
  # Agregar etiquetas 
  geom_text(aes(label = after_stat(count)), stat = "count", vjust = 0)  +
  labs(x = "PBS",
       y = "Frecuencia",
       title = "Dispensaciones por plan de beneficios") +
  theme_bw()

# mas de un grupo no apilado

ggplot(
  data = df_med,
  mapping = aes(x = pbs,
                fill = tipo_entrega)) +
  geom_bar(position = "dodge") +
  geom_text(aes(label = after_stat(count)),
            stat = "count",
            position = position_dodge(0.9),
            vjust = 0)  +
  labs(x = "PBS",
       y = "Frecuencia",
       title = "Dispensaciones por plan de beneficios",
       fill = "Tipo de entrega") +
  theme_bw()

# Agregar etiquetas por grupos apilados al 100%

ggplot(df_med, aes(x = pbs, fill = tipo_entrega)) +
  geom_bar(position = "fill") +
  geom_text(
    aes(
      # etiqueta de datos en formato porcentual
      label = scales::percent(after_stat(count)/sum(after_stat(count)))
    ),
    stat = "count", 
    # posición de la etiqueta en el centro de cada grupo
    position = position_fill(vjust = 0.5)) +
  # etiquetas en porcentaje del eje y
  scale_y_continuous(labels = scales::percent) +
  labs(x = "PBS",
       y = "%",
       title = "Dispensaciones por plan de beneficios", 
       fill = "Tipo de entrega") + 
  theme_bw()


# Personalizar colores en `fill` ------------------------------------------

# Podemos personalizar los colores de los grupos usando `scales_fill_manula()`
# Los colores en R tienen nombres clave como `red` o `blue`
# También podemos usar códigos de colores como `#5DC3DA`

ggplot(df_med, aes(x = pbs, fill = tipo_entrega)) +
  geom_bar(position = "fill") +
  geom_text(aes(label = scales::percent(after_stat(count)/sum(after_stat(count)))),
            stat = "count", 
            position = position_fill(vjust = 0.5)) +
  # colores de los grupos 
  scale_fill_manual(values = c("darkgreen", "#5DC3DA")) +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "PBS",
       y = "Frecuencia",
       title = "Dispensaciones por plan de beneficios", 
       fill = "Tipo de entrega") + 
  theme_bw()


# Usando `facets` para estratificar gráficos ------------------------------

# El comando `facet_wrap()` permite crear mini gráficos por grupos en un solo gráfico
# El comando `facet_grid()` permite crear una matriz de gráficos

ggplot(data = df_med,
       mapping = aes(x = pbs, fill = tipo_entrega)) +
  geom_bar(position = "fill") +
  geom_text(aes(label = scales::percent(after_stat(count)/sum(after_stat(count)), accuracy = 0.1)),
            stat = "count",
            position = position_fill(vjust = 0.5)) +
  scale_fill_manual(values = c("#54504F", "#5DC3DA")) +
  labs(x = "PBS",
       y = "Frecuencia",
       title = "Dispensaciones por plan de beneficios",
       fill = "Tipo de entrega") +
  theme_bw() +
  # dividir el gráfico por grupos
  facet_wrap(~cronico)


# Gráfico de linea usando `geom_line()` y `geom_point()` ------------------

# Un gráfico de línea se usa para mostrar evolución o cambio
# Vamos a crear un gráfico de líneas de las dispensaciones por mes
# Usamos `geom_line()` combinado con `geom_point()` para hacer gráficos de líneas

# creamos las variables
df_disp <- df_med %>% 
  mutate(
    fecha_entrega = dmy(fecha_entrega),
    mes_disp = floor_date(fecha_entrega, "month")
  ) %>% 
  count(mes_disp)

ggplot(df_disp, aes(x = mes_disp, y = n)) +
  geom_line(color = "tomato") +
  geom_point(color = "tomato") +
  geom_text(aes(label = n, y = n + 5), vjust = 0, nudge_y = 0.5) +
  scale_x_date(date_breaks = "months", date_labels = "%m/%Y") +
  labs(
    x = "Mes de dispensación",
    y = "Cantidad"
  ) +
  theme_bw()


# Gráfico de linea usando `geom_line()`,  `geom_point()` y `facet_ --------

# Usando  `facet_wrap()` podemos crear mini gráficos de líneas

# creamos las variables
df_disp <- df_med %>% 
  mutate(
    fecha_entrega = dmy(fecha_entrega),
    mes_disp = floor_date(fecha_entrega, "month")
  ) %>% 
  filter(departamento != "0") %>% 
  count(departamento, mes_disp)

ggplot(df_disp, aes(x = mes_disp, y = n)) +
  geom_line(color = "tomato") +
  geom_point(color = "tomato") +
  geom_text(aes(label = n, y = n), vjust = 0, nudge_y = 0.5) +
  scale_x_date(date_breaks = "months", date_labels = "%m/%Y") +
  labs(
    x = "Mes de dispensación",
    y = "Cantidad"
  ) +
  facet_wrap(~departamento, scales = "free_y") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90))

# Guardar un gráfico ------------------------------------------------------

# Usamos el comando `ggsave()` para guardar un gráfico
# O podemos usar la ventana `Plots > Export > Save imagen as`

# mi grafico 
plot_pbs <- ggplot(df_med, aes(x = pbs, fill = tipo_entrega)) +
  geom_bar(position = "fill") +
  geom_text(
    aes(
      # etiqueta de datos en formato porcentual
      label = scales::percent(after_stat(count)/sum(after_stat(count)))
    ),
    stat = "count", 
    # posición de la etiqueta en el centro de cada grupo
    position = position_fill(vjust = 0.5)) +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "PBS",
       y = "%",
       title = "Dispensaciones por plan de beneficios", 
       fill = "Tipo de entrega") + 
  theme_bw()

# guardar
ggsave(filename = "resultados/plot_pbs.png", plot_pbs)

