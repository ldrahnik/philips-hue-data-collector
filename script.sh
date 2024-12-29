#!/usr/bin/env bash

API_TEMPERATURE_SENSOR_URL="$API_HOST/api/$API_USERNAME/sensors/$API_TEMPERATURE_SENSOR_ID"
API_AMBIENT_LIGHT_SENSOR_URL="$API_HOST/api/$API_USERNAME/sensors/$API_AMBIENT_LIGHT_SENSOR_ID"

TEMPERATURE_SENSOR_OUTPUT_FILE="$LOGS_DIR/temperature_sensor.csv"
AMBIENT_LIGHT_SENSOR_OUTPUT_FILE="$LOGS_DIR/ambient_light_sensor.csv"

function save_current_state_of_sensor_to_file() {

  API_URL=$1
  OUTPUT_FILE=$2

  current_date_time=$(date -u +"%Y-%m-%dT%H:%M:%S")

  # Fetch the data from the API
  response=$(curl -s "$API_URL")

  if [[ -z "$response" ]]; then
    echo "$current_date_time: Error: Failed to fetch data from API." >&2
    exit 1
  fi

  # Extract the state object as key-value pairs
  state=$(echo "$response" | jq -r '.state | to_entries | map("\(.key)=\(.value|tostring)") | join(",")')

  # Extract the lastupdated timestamp
  lastupdated=$(echo "$response" | jq -r .state.lastupdated)

  if [[ -z "$state" || -z "$lastupdated" ]]; then
    echo "$current_date_time: Error: Invalid data from API." >&2
    exit 1
  fi

  # Create the CSV file if it doesn't exist
  if [[ ! -f "$OUTPUT_FILE" ]]; then
    echo "Datetime,State" > "$OUTPUT_FILE"
  fi

  # Check for duplicate entry based on the lastupdated value
  if ! grep -q "^$lastupdated;" "$OUTPUT_FILE"; then
    echo "$current_date_time: Writing state for datetime: $lastupdated"
    echo "$lastupdated;\"$state\"" >> "$OUTPUT_FILE"
  else
    echo "$current_date_time: Skipping duplicate entry for datetime: $lastupdated"
  fi
}

# Save the states of the temperature and ambient light sensors to their respective files
save_current_state_of_sensor_to_file "$API_TEMPERATURE_SENSOR_URL" "$TEMPERATURE_SENSOR_OUTPUT_FILE"
save_current_state_of_sensor_to_file "$API_AMBIENT_LIGHT_SENSOR_URL" "$AMBIENT_LIGHT_SENSOR_OUTPUT_FILE"

exit 0