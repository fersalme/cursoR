# cargar libreria
library(lubridate)

# fecha con tiempo
fecha_incidente <- "12/01/2023 14:00:00"
class(fecha_incidente)

# cambiar el formato a fecha y conservar el tiempo
fecha_incidente <- dmy_hms(fecha_incidente)
class(fecha_incidente)

# agregar tiempo a la fecha
fecha_incidente + 30
fecha_incidente + 60*60
fecha_incidente + (72*60*60) # 72 horas

# fecha limite
fecha_limite <- fecha_incidente + (72*60*60)

# otra fecha de requerimiento
fecha_incidente <- "12/01/2023 17:30:01"
fecha_incidente <- dmy_hms(fecha_incidente)
fecha_limite <- fecha_incidente + (72*60*60)
fecha_limite

# diferencia de fechas con tiempo
fecha_incidente <- dmy_hms("01/01/2023 09:23:12")
fecha_resolucion <- dmy_hms("04/01/2023 10:30:00")
diff_tiempo <- fecha_resolucion - fecha_incidente
diff_tiempo <= 3
