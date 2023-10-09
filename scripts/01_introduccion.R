# -------------------------------------------------------------------------
# Título : Comenzando con R
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : ALZAK Foundation
# Correo : fsalcedo@alzakfoundation.org
# Fecha de creación : 2023-08-26
# Licencia : MIT-Copyright (c) 2023 Fernando Salcedo Mejía
# -------------------------------------------------------------------------
# Notas : Ver presentación 02_introduccion_R.html
# -------------------------------------------------------------------------

# Aritmética con R --------------------------------------------------------

# R puede ser usado como una simple calculadora

# Suma
5 + 5 

# Resta
10 - 5 

# Multiplicación
3 * 5

# División 
(5 + 5) / 2 

# Potencia
2^5

# Módulo. (Remanente de dividir 28 entre 6)
28%%6


# Asignar valores ---------------------------------------------------------

# Podemos crear **variables** asignándoles valores usando `<-`
# R no reemplaza, sobrescribe o modifica un elemento si no usamos `<-`

# Variable edad
edad <- 32

# ver el contenido de la variable
edad

# usando el comando print()
print(edad)

# Asignar valores II ------------------------------------------------------

# Podemos hacer operaciones aritméticas entre variables solo usando sus nombres.

# edad de José
edad_jose <- 45

# edad María
edad_maria <- 34

# diferencia de edades entre María y José
edad_jose -  edad_maria

# Tipo de datos en R ------------------------------------------------------

# `R` trabaja con numerosos tipos de datos. Los tipos más básicos son:
# `numerics` como `1.5`
# `integers` como 4
# `logical` solo valores `TRUE` y `FALSE`
# `characters` como `"introducción a R"`
# `date` como `2023-08-01` (`R` solo usa formato YYYY-MM-DD para las fechas)

# valor numerico
peso_maria <- 78.4

# valor entero
n_carros <- 12L

# valor logico
es_dia <- TRUE

# valor de texto
direccion_casa <- "CLL 34 # 56-4A"

# valor de fecha
fecha_hoy <- Sys.Date() # Sys.Date() es a fecha de hoy

# clases de variables
class(peso_maria)
class(n_carros)
class(es_dia)
class(direccion_casa)
class(fecha_hoy)


# Vectores ----------------------------------------------------------------

# R trabaja con estructuras de datos. La estructua de datos más simple es un *vector*
# Un *vector* es una colección de elementos (número, texto, fechas, lógico)
# Usamos el operador `c()` para crear un vector

# ingresos en dolares
# vectores de edad y nombres
edades <- c(12, 23, 36, 45)
nombres <- c("Carlos", "María", "José", "Manuel")

edades
nombres


# Operaciones con vectores ------------------------------------------------

# El vector tiene un número de elementos (`length()`) y posición (`[]`) de esos elementos

length(edades) # número de elementos
edades[2] # mostrar el elemento en la posición 2

# Nombres elementos de un vector
# Es posible asignar nombres a los elementos de un vector `names()`

# asignamos un vector de carácter del mismo largo del vector de edades
names(edades) <- nombres 
edades
edades["Carlos"] # ver la edad de Carlos
names(edades) # si usamos names() obtenemos los nombres
names(edades)[2] <- "Julia" # cambiar el nombre para el segundo elemento
edades # vemos los cambios


# Operaciones aritméticas de vectores I -----------------------------------

# Podemos hacer operaciones con vectores numéricos
# Los elementos se operan desde la misma posición

# vectores de ingresos y gastos
ingresos <- c(34, 44, 48, 90, 56)
gastos <- c(23, 53, 37, 97, 34)
meses <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo")

# nombres mes
names(ingresos) <- meses
names(gastos) <- meses

ingreso_disponible <- ingresos - gastos
ingreso_disponible


# Operaciones aritméticas de vectores II ----------------------------------

# Podemos hacer operaciones de **resumen** vectores numéricos

# minimo ingreso
min(ingresos)
# maximo ingreso
max(ingresos)
# total de ingresos
sum(ingresos)
# ingresos promedios
mean(ingresos)


# Secuencias y creación rápida de vectores --------------------------------

# Podemos hacer secuencias de elementos con comando `seq()`
# Si la secuencia es de uno a uno usamos el operador `:`
# Podemos crear vectores repitiendo elementos `rep()`

(x <- seq(from = 1, to = 20)) # secuencia de número de 1 al 20
(x <- 1:20) # versión rápida
(x <- seq(2, 20, by = 2)) # secuencia de número de 1 al 20 incrementando por 2

(y <- rep(x, 2)) # repetir el vector 2 veces
(y <- rep(x, each = 2)) # repetir cada elemento 2 veces

# Vectores de caracteres --------------------------------------------------

# Los caracteres se colocan entre comillas `hola`
# El comando `paste()` y `paste0()` permite combinar vectores de caracteres

nombres <- c("Carlos", "María", "José", "Manuel")
apellidos <- c("Sanchez", "Mejía", "Valencia", "Mora") 
nombres_completos <- paste(nombres, apellidos) # combinamos los nombres y apellidos en nuevo vector
nombres_completos


# Mayusculas y minusculas -------------------------------------------------

# Para pasar de minúsculas a mayúsculas usamos `toupper()`
# Ahora de mayúsculas a minúsculas `tolower()`

toupper(nombres)
tolower(nombres)

# Vector lógico y operadores ----------------------------------------------

# Desigualdades `<, <=, >, >=`
# Identidad `==`
# Inequidad o negación `!=`
# Dos vectores `c1` y `c2` son vectores lógicos
# `c1 & c2` es la intercepción o conjugación "Y"
# `c1 | c2` es la unión "O"
# `!c1` sería la negación, convirtiendo `TRUE -> FALSE` y viceversa
# `c1 %in% c2` es la operación coincidir elementos de `c1` en `c2`

# Un vector lógico contiene valores FALSO (`FALSE`) y VERDADERO (`TRUE`)
# También evaluar una condición sobre un vector devuelve un vector lógico.

5 > 2 # TRUE
x <- 1:20 
x > 10 # elementos del vector de 1 al 20 que cumplen la condición
(y <- x > 10)


# Vector de fechas --------------------------------------------------------

# Las fechas en `R` usan el formato YYYY-MM-DD
# Para ingresar una fecha usamos el comando `as.Date()`
# Si queremos la fecha de hoy usamos `Sys.Date()`

(x <- as.Date(c("2021-01-12", "2021-01-01", "2021-04-12")))
class(x)
(x <- Sys.Date() + 1:5) # vector de fechas a patir de hoy

# Valores perdidos --------------------------------------------------------

# Un valor perdido no es más que un valor ausente en un vector
# Se usa para representarlo `NA`
# El comando `is.na()` evalúa si en un vector hay datos perdidos

x <- c(1:5, NA)
is.na(x) # comprueba si los valores son NA


# Indexación y segmentación -----------------------------------------------

# Los operadores lógicos nos permiten seleccionar los elementos de un vector que cumplen una condición (operadores lógicos!) 🚨
# La forma de usarlo es con los corchetes `[]`
# También podemos eliminar un elemento de un vector con el signo menos (`-`) y la posición del elemento

# ingresos mayores que el promedio
mejores_ingresos <- ingresos > mean(ingresos)
ingresos[mejores_ingresos]

# no sabemos el valor de ingresos para el mes de Enero
ingresos["Enero"] <- NA
ingresos[1] <- NA
ingresos

# ingresos sin valores perdidos (NA)
# negar la condición devuelve TRUE donde antes era FALSE
ingresos[!is.na(ingresos)] 

# eliminar del vector de ingresos el primer mes
ingresos[-1]


# Reemplazar valores en un vector -----------------------------------------

# Para reemplazar un valor dentro de un vector usamos
# Posición `x[index] <- valor`
# Condiciones `x[x > valor1]<- valor2`

# reemplazar el mes de enero con otro valor
ingresos[1] <- 120
ingresos["Enero"] <- 120

ingresos


# Posición de elementos por condición -------------------------------------

# Podemos identificar la posición de un valor dentro de un vector usando `which()`, `which.max()`, `which.min()` 

# posicion ingresos menores que el promedio
i_menor_ingreso <- which(ingresos < mean(ingresos))
i_menor_ingreso
ingresos[i_menor_ingreso]

# mes con el peor ingreso
ingresos[which.min(ingresos)]

# mes con el mejor ingreso
ingresos[which.max(ingresos)]


# Coercionar vectores de tipo ---------------------------------------------

# Para cambiar un vector `character -> numeric` usamos `as.numeric()`
# Para cambiar un vector `numeric ->` usamos `as.character()`

x <- c("1", "3", "a", "7")
(x <- as.numeric(x)) # tenemos datos NA
class(x)
x <- 1:4
(x <- as.character(x)) # notemos que los números están entre comillas
class(x)


# Ordenar elementos de un vector ------------------------------------------

# Para ordenar usamos el comando `sort()`

temp <- c(34, 55, 45, 34, 22, 10)

# ordenar de menos a mayor
sort(temp)

# ordenar de mayor a menor
sort(temp, decreasing = TRUE)

# Matrices ----------------------------------------------------------------

# Es una colección de valores del mismo tipo arreglados en filas y columnas
# Para crear matrices se usa el comando `matrix()`

calificaciones <- matrix(c(5, 5, 2, 0, 4,
                           4, 3, 1, 1, 5,
                           3, 3, 0, 3, 0), byrow = TRUE, ncol = 3)

rownames(calificaciones) <- c("Carlos", "María", "José", "Manuel", "Antonio")
colnames(calificaciones) <- c("Matemáticas", "Idiomas", "Sociales")

calificaciones


# Dimensiones de una matriz -----------------------------------------------

# Usamos el comando `dim()` para saber el número de filas y columnas

dim(calificaciones)


# Extraer elementos de una matriz -----------------------------------------

# Usamos la posición de fila y columnas `[i, j]` para extraer una fila, columna o elemento de las matriz

# calificaciones de Matemáticas
calificaciones[,"Matemáticas"]

# calificaciones de Carlos
calificaciones["Carlos", ]

# calificación de María en Idiomas
calificaciones["María", "Idiomas"]


# Operaciones y resumen de matrices ---------------------------------------

# Podemos aplicar operaciones a las columnas y filas de las matrices con `rowSums()`, `rowMeans()`, `colSums()`, `colMeans()`

# promedio de calificaciones por estudinate
rowMeans(calificaciones)
# promedio de calificiaciones por metria
colMeans(calificaciones)


# data.frames o cuadros de datos ------------------------------------------

# Un `data.frame` es un arreglo de vectores en filas y columnas de distintos tipos
# En contexto, las filas son observaciones y las columnas variables
# Para crear un `data.frame` usamos el comando `data.frame()`

# cada variable es un vector y debe  ser del mismo largo
df_encuesta <- data.frame(
  id = 1:10, 
  sexo = c("F", "F", "M", "M", "F", "M", "M", "F", "M", "F"),
  edad = c(19, 45, 24, 19, 34, 20, 67, 34, 35, 10),
  ingresos = c(120, 134, 198, 455, 678, 564, 123, 632, 90, 124)
)

df_encuesta
class(df_encuesta) # nueva clase, data.frame


# Atributos de un data.frame ----------------------------------------------

# Para el número de filas o observaciones usamos `nrow()`
# Para el número de variables o columnas usamos `ncol()`
# Para los nombres de las variables usamos `names()`
# La estructura del `data.frame` la vemos con `str()`

nrow(df_encuesta) # filas del data.frame
ncol(df_encuesta) # columnas del data.frame
names(df_encuesta) # nombres de las variables
str(df_encuesta) # vista de la estructura del data.frame


# Formas de ver un data.frame ---------------------------------------------

# No es necesario ver todo un `data.frame` para entender cómo es la estructura o qué contiene
# Para ver el encabezado usamos `head()`
# Para ver las últimas filas usamos `tail()`
# Si queremos verlo al detalle completo usar `Views()`

head(df_encuesta) # primeras 6 observaciones
tail(df_encuesta) # ultimas 6 observaciones
View(df_encuesta) # ver todos los datos


# Cambiar los nombres de un data.frame ------------------------------------

# Tal como en los vectores, usamos `names(df)[index] <- "nuevo_nombre"`

names(df_encuesta)[1] <- "identificacion" # siempre entre comillas el nuevo nombre
names(df_encuesta)

# Algunas recomendaciones de los nombres en el data.frame -----------------

# Nombres cortos, código corto y sencillo
# Para nombres con espacios usar `"_"` como por ejemplo `codigo_paciente`. Esto es más fácil de leer que `codigopaciente`
# Evitar usar `"."` como separador de espacios en los nombres (`nombre.paciente`), debido a que hay funciones con ese carácter
# No repetir el nombre de una variable en el mismo `data.frame`


# Selección de filas y variables en un data.frame -------------------------

# Para ello, usamos los corchetes `[]`
# Para seleccionar variables usamos `df["nombre_variable"]` o la posición `df[index]`
# Para seleccionar filas usamos `df[index, ]`

df_encuesta["sexo"] # solo la variable sexo con todas las observaciones
df_encuesta[1, ] # solo la primera observación con todas las variables
df_encuesta[c("identificacion", "sexo")] # solo las variables identificación y sexo con todas las observaciones
df_encuesta[1:3, ] # solo las primeras tres observaciones


# Operador $ y [[]] -------------------------------------------------------

# `$` y `[[]]` permite extraer una columna de un `data.frame` como vector

# vector de edades
edades_encuesta <- df_encuesta$edad
edades_encuesta
# vector de ingresos 
ingreso_encuesta <- df_encuesta[["ingresos"]]
ingreso_encuesta


# Cambio de orden en un data.frame ----------------------------------------

# Si queremos ordenar un `data.frame` por alguna variable usamos `order()`
# Para cambiar el orden de las variables usamos `cbind()` o indexamos por un vector de nombres `df[vector_nombres]`

# ordenar por edad de menor a mayor
df_encuesta[order(df_encuesta$edad), ]
# ordenar por edad de mayor a menor
df_encuesta[order(df_encuesta$edad, decreasing = TRUE), ]


# Segmentación de data.frames ---------------------------------------------

# Para filtrar filas dentro de un `data.frame` usamos los operadores lógicos
# Tal como vimos en los vectores y la indexación, las **filas que cumplan la condición son las que se muestran (`TRUE`)**
# Si vamos a usar muchas condiciones conviene usar el comando `subset()`

# filtrar las observaciones del sexo F
df_encuesta[df_encuesta$sexo == "F", ]

# usando el comando subset()
subset(df_encuesta, sexo == "F")

# filtrar las observaciones del sexo M y edades >= 30
df_encuesta[df_encuesta$edad >= 30 & df_encuesta$sexo == "M", ] 
subset(df_encuesta, edad >= 30 & sexo == "M")


# Agregar una nueva variable al data.frame --------------------------------

# Usamos el operador `$` o `[[]]` para crear una variable nueva en el `data.frame`

df_encuesta$gastos <- c(72, 43, 30, 406, 364, 178, 7, 449,  13,  43)

df_encuesta


# Reemplazar valores en un data.frame -------------------------------------

# Se reemplazan valores que cumplen una condición

# reemplazar la edad en el id = 1
df_encuesta$edad[df_encuesta$id == 1] <- 34
df_encuesta


# Listas ------------------------------------------------------------------

# Las listas son un arreglo de elementos de distintos tipos y es otra estructura de datos.
# Su uso está destinado a agrupar en un solo objeto diversidad de elementos que tengan alguna relación pero que **no se pueden combinar**
  
df_ventas <- data.frame(
  id_producto = c(5, 1, 1, 2, 5, 4, 1, 5, 1, 2),
  cantidad = c(81, 52, 23, 8, 17, 84, 84, 65, 60, 2)
)

df_productos <- data.frame(
  id_producto = 1:5,
  descripcion = c("Leche", "Carne", "Huevos", "Pan", "Harina"),
  medida = c("ml", "gr", "und", "und", "gr")
)

df_precios <- data.frame(
  id = 1:5,
  precio = c(134, 345, 190, 34, 12)
)

# lista de ventas
list_ventas <- list(
  ventas = df_ventas,
  productos = df_productos,
  precios = df_precios
)

# estructura 
str(list_ventas, max.level = 1)
str(list_ventas, max.level = 2)


# Manipulación de listas --------------------------------------------------


# Las listas son colecciones de objetos ordenados en secuencia `list()`
# Las listas nos permiten tener diferentes objetos tal como un `vector`o un `data.frame`

# numero de elementos
length(list_ventas)
# nombres de los objetos en la lista
names(list_ventas)
# ver un objeto dentro de una lista
list_ventas[[1]]
list_ventas[["ventas"]]
list_ventas$ventas
list_ventas$ventas$cantidad

