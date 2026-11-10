#!/bin/bash
if [[ $# -lt 1 ]]; then
    echo "❌ Error: Debes proporcionar el nombre del archivo de salida"
    echo "Uso: ./test-availability.sh <nombre_archivo>"
    exit 1
fi

OUTPUT_FILE="$1"
ENDPOINT_URL="http://localhost:8080/v1/products"
NUM_REQUESTS=200

> "$OUTPUT_FILE"
echo "Ejecutando $NUM_REQUESTS solicitudes a $ENDPOINT_URL..."

for i in $(seq 1 "$NUM_REQUESTS"); do
    response_file=$(mktemp)
    metadata=$(curl -sS -o "$response_file" -w "%{http_code} %{time_total}" "$ENDPOINT_URL")
    body=$(cat "$response_file" | tr '\n' ' ')
    printf '%03d %s %s\n' "$i" "$metadata" "$body" | tee -a "$OUTPUT_FILE"
    rm -f "$response_file"
done

echo ""
echo "Resultados guardados en: $OUTPUT_FILE"
echo ""

SUCCESS=$(grep -c '"status":"SUCCESS"' "$OUTPUT_FILE" || true)
HTTP_200=$(grep -cE '^[0-9]+ 200 ' "$OUTPUT_FILE" || true)
HTTP_ERRORS=$(grep -cEv '^[0-9]+ 200 ' "$OUTPUT_FILE" || true)
TOTAL=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')

if [[ $TOTAL -gt 0 ]]; then
    AVAILABILITY=$(echo "scale=4; $HTTP_200 / $TOTAL" | bc)
    echo "Respuestas SUCCESS: $SUCCESS"
    echo "Respuestas HTTP 200: $HTTP_200"
    echo "Respuestas HTTP distintas de 200: $HTTP_ERRORS"
    echo "Solicitudes totales: $TOTAL"
    echo "Disponibilidad observada: $AVAILABILITY"
fi
