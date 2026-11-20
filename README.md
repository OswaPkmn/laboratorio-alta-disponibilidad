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

3. Laboratorio 1.3: De Docker a Kubernetes Local
- Archivo de evidencia: unidad-1-ha-architecture/02-laboratorio/proyecto-base-unidad-01/kubernetes-deployment-evidence.txt
- Manifiestos aplicados: k8s/01-deployment.yaml y k8s/02-service.yaml
- Imagen publicada: oswapkmn/catalog-service:1.0.0 (Docker Hub)
- Explicacion: Se compilo el microservicio con Maven y se empaqueto en una imagen Docker publicada en Docker Hub (oswapkmn/catalog-service:1.0.0) para simular un flujo CI/CD reproducible. Posteriormente, se definio el despliegue de forma declarativa mediante manifiestos YAML en Kubernetes (Minikube). A diferencia de la validacion manual del Laboratorio 1.1, se configuraron sondas automaticas de salud en el Deployment: readinessProbe consulta /ready cada 5 segundos para habilitar el trafico al pod, y livenessProbe consulta /live cada 10 segundos para reiniciar el contenedor en caso de bloqueo. Finalmente, se expuso el servicio mediante un ClusterIP y se verifico via port-forward que los endpoints responden con estado UP y datos operativos.
