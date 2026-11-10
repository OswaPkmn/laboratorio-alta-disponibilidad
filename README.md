Laboratorio Unidad 1: Alta Disponibilidad y Resiliencia en Microservicios

Repositorio que contiene las evidencias, codigo fuente y bitacoras correspondientes a los laboratorios de alta disponibilidad (Quarkus / SmallRye Fault Tolerance).

1. Laboratorio 1.1: Medicion de Linea Base (Baseline)
- Archivo de evidencia: unidad-1-ha-architecture/02-laboratorio/proyecto-base-unidad-01/availability-baseline.txt
- Metrica obtenida: 67.5% de disponibilidad (135 aciertos / 65 errores HTTP 500 de 200 peticiones).
- Explicacion: El microservicio carece de mecanismos de proteccion ante fallas. Opera de manera vulnerable frente a las intermitencias simuladas en la base de datos (30% de probabilidad de error y 20% de latencia de 3s). Al no haber un interceptor, las fallas se propagan directamente como errores HTTP 500 y las consultas lentas bloquean los hilos de ejecucion, reduciendo la disponibilidad global.

2. Laboratorio 1.2: Patrones de Resiliencia (Timeout y Fallback)
- Archivo de evidencia: unidad-1-ha-architecture/02-laboratorio/proyecto-base-unidad-01/resilience-sample.txt
- Codigo modificado: unidad-1-ha-architecture/02-laboratorio/proyecto-base-unidad-01/catalog-service/src/main/java/com/ecom/catalog/CatalogResource.java
- Metrica obtenida: 100% de disponibilidad (200 respuestas controladas / 0 errores HTTP 500).
- Explicacion: Se instrumento el codigo con @Timeout(800) para interrumpir consultas lentas que rebasen los 800ms y @Fallback(fallbackMethod = "fallbackProducts") para retornar una respuesta degradada desde cache (DEGRADED_CACHE) ante cualquier fallo de conexion. Esto elimino la propagacion de errores al usuario y elevo la disponibilidad al 100%.
