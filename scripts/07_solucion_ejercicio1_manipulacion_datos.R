# ----------------------------------------------------
# Título : Solución ejercicio 1 manipulación datos
# Autor(es) : Fernando Salcedo Mejía
# Afiliación : Economista
# Fecha de creación : 2023-09-16
# ----------------------------------------------------
# Notas : 
# ----------------------------------------------------

# cargar librerias
library(tidyverse)
library(janitor)
library(writexl)

# cargar los datos medicamentos
# que separador tiene los datos
readLines(con = "datos/base_medicamentos.csv", n = 3)
df_med <- read_csv2(file = "datos/base_medicamentos.csv")

# limpiar nombres
df_med <- clean_names(df_med)

# ajustar formato fecha_entrega
df_med$fecha_entrega <- dmy(df_med$fecha_entrega)

# crear mes y año
df_med <- df_med %>% 
  mutate(
    mes = month(fecha_entrega),
    año = year(fecha_entrega)
  )

# dispensacion de medicamentos
df_disp_cardio <- df_med %>% 
  filter(familia == "CARDIOVASCULAR") %>% 
  count(departamento, municipio, año, mes, name = "dispensacion")

# ajuste departamento 0 = no definido
df_disp_cardio <- df_disp_cardio %>% 
  mutate(
    departamento = case_when(
      departamento == "0" ~ "NO DEFINIDO",
      TRUE ~ departamento
    ),
    municipio = case_when(
      municipio == "0" ~ "NO DEFINIDO",
      TRUE ~ municipio
    )
  )

# trasponer los datos colocando los meses en las columnas
df_disp_cardio_tras <- df_disp_cardio %>% 
  arrange(mes) %>% 
  pivot_wider(names_from = mes, 
              values_from = dispensacion, 
              names_prefix = "mes_", 
              values_fill = 0)

# exportar a excel
write_csv(df_disp_cardio, file = "datos/base_disp_cardio.csv")
write.csv(df_disp_cardio, file = "datos/base_disp_cardio2.csv", row.names = FALSE)

write_xlsx(df_disp_cardio, path = "datos/base_disp_cardio.xlsx")

# lista de bases por departamento
list_disp_dpto <- df_disp_cardio %>% 
  split(.$departamento)

write_xlsx(list_disp_dpto, path = "datos/base_disp_cardio_dpto.xlsx")

# guardar en formato R
# RDS
saveRDS(df_disp_cardio,
        file = "datos/base_disp_cardio.rds")
df_disp_cardio <- readRDS(file = "datos/base_covid_bolivar.rds")

# save RData
save(df_disp_cardio, list_disp_dpto,
     file = "datos/datos_cardio.RData")
load(file = "datos/datos_cardio.RData")

