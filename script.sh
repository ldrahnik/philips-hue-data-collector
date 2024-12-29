#!/usr/bin/env bash

API_URL="$API_HOST/api/$API_USERNAME/sensors/$API_TEMPERATURE_SENSOR_ID"
OUTPUT_FILE="$LOGS_DIR/data.csv"

current_date_time=$(date)

response=$(curl -s "$API_URL")

if [[ -z "$response" ]]; then
    echo "$current_date_time: Error: Failed to fetch data from API." >&2
    exit 1
fi

datetime=$(echo "$response" | jq -r .state.lastupdated)
temperature=$(echo "$response" | jq -r .state.temperature)
temperature=$(echo "scale=2; $temperature / 100" | bc -l)

if [[ -z "$datetime" || "$datetime" == "null" || -z "$temperature" || "$temperature" == "null" ]]; then
    echo "$current_date_time: Error: Invalid data from API. Datetime or temperature is missing." >&2
    exit 1
fi

if [[ ! -f "$OUTPUT_FILE" ]]; then
    echo "Datetime,Temperature" > "$OUTPUT_FILE"
fi

if ! grep -q "^$datetime," "$OUTPUT_FILE"; then
    echo "$current_date_time: Writting $temperature for datetime: $datetime"
    echo "$datetime,$temperature" >> "$OUTPUT_FILE"
else
    echo "$current_date_time: Skipping duplicate entry for datetime: $datetime"
fi

exit 0