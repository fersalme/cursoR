# ----------------------------------------------------
# Título : Creación y manipulacion data.frame
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : Economista
# Fecha de creación : 2023-08-26
# ----------------------------------------------------
# Notas : 
# ----------------------------------------------------


# estratucra data.frame ---------------------------------------------------

df_encuesta <- data.frame(
  id = 1:10,
  sexo = c("F", "M", "M", "M", "F", "F", "F", "M", "F", "M"),
  edad = c(2, 3, 5, 6, 34, 12, 56, 7, 90, 23)
)

# ver data.frame
df_encuesta
View(df_encuesta)

# ver atributos del data.frame
dim(df_encuesta)
str(df_encuesta)
nrow(df_encuesta)
ncol(df_encuesta)

# manipulacion data.frame -------------------------------------------------

names(df_encuesta)
names(df_encuesta)[1] <- "identificacion"
names(df_encuesta)

df_encuesta["sexo"]
df_encuesta[c("identificacion", "sexo")]

df_encuesta[1:3, c("identificacion", "sexo")]
sexo <- df_encuesta$sexo

