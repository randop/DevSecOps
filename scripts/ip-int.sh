#!/usr/bin/env bash
set -euo pipefail

# TODO: replace with actual values
BASE_ID=$(pass show airtable/ip-int-base)
TABLE=$(pass show airtable/ip-int-table)

AIRTABLE_PAT_TOKEN="${AIRTABLE_PAT_TOKEN:?AIRTABLE_PAT_TOKEN is not set}"
INPUT_FILE="${INPUT_FILE:-unique_ips.txt}"

API_URL="https://api.airtable.com/v0/${BASE_ID}"
TODAY="$(date -u '+%Y-%m-%d')"

command -v curl >/dev/null 2>&1 || {
  echo "ERROR: curl is required" >&2
  exit 1
}
command -v jq >/dev/null 2>&1 || {
  echo "ERROR: jq is required" >&2
  exit 1
}
[[ -f "$INPUT_FILE" ]] || {
  echo "ERROR: input file not found: $INPUT_FILE" >&2
  exit 1
}

airtable_get() {
  curl --silent --show-error --fail-with-body --retry 3 --retry-delay 2 \
    --request GET "$1" \
    --header "Authorization: Bearer ${AIRTABLE_PAT_TOKEN}"
}

airtable_post() {
  curl --silent --show-error --fail-with-body --retry 3 --retry-delay 2 \
    --request POST "$1" \
    --header "Authorization: Bearer ${AIRTABLE_PAT_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "$2"
}

airtable_patch() {
  curl --silent --show-error --fail-with-body --retry 3 --retry-delay 2 \
    --request PATCH "$1" \
    --header "Authorization: Bearer ${AIRTABLE_PAT_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "$2"
}

find_ip() {
  local ip="$1"
  local formula encoded_formula

  formula="$(jq -rn --arg ip "$ip" \
    '$ip | @json | "{IP Address} = " + .')"

  encoded_formula="$(jq -rn --arg formula "$formula" \
    '$formula | @uri')"

  airtable_get \
    "${API_URL}/${TABLE}?filterByFormula=${encoded_formula}&maxRecords=1"
}

create_ip() {
  local ip="$1"
  local payload

  payload="$(jq -cn --arg ip "$ip" --arg today "$TODAY" '{
        records: [{
            fields: {
                "IP Address": $ip,
                "First Seen": $today,
                "Last Seen": $today
            }
        }]
    }')"

  airtable_post "${API_URL}/${TABLE}" "$payload"
}

update_ip() {
  local record_id="$1"
  local payload

  payload="$(jq -cn --arg today "$TODAY" '{
        fields: {
            "Last Seen": $today
        }
    }')"

  airtable_patch "${API_URL}/${TABLE}/${record_id}" "$payload"
}

created=0
updated=0
failed=0

while IFS= read -r ip || [[ -n "$ip" ]]; do
  ip="${ip//$'\r'/}"
  ip="$(sed 's/^[[:space:]]*//;s/[[:space:]]*$//' <<<"$ip")"

  [[ -z "$ip" ]] && continue
  [[ "$ip" == \#* ]] && continue

  echo "Checking: $ip"

  if ! response="$(find_ip "$ip")"; then
    echo "  ERROR: failed to query Airtable" >&2
    ((failed += 1))
    continue
  fi

  record_id="$(jq -r '.records[0].id // empty' <<<"$response")"

  if [[ -n "$record_id" ]]; then
    existing_first_seen="$(
      jq -r '.records[0].fields["First Seen"] // empty' <<<"$response"
    )"
    existing_last_seen="$(
      jq -r '.records[0].fields["Last Seen"] // empty' <<<"$response"
    )"

    echo "  EXISTS: $record_id"
    echo "  First Seen: ${existing_first_seen:-missing}"
    echo "  Last Seen:  ${existing_last_seen:-missing}"
    echo "  Updating Last Seen -> $TODAY"

    if update_ip "$record_id" >/dev/null; then
      ((updated += 1))
      echo "  OK"
    else
      echo "  ERROR: failed to update record" >&2
      ((failed += 1))
    fi
  else
    echo "  NEW IP"
    echo "  First Seen -> $TODAY"
    echo "  Last Seen  -> $TODAY"

    if create_response="$(create_ip "$ip")"; then
      new_record_id="$(
        jq -r '.records[0].id // "unknown"' <<<"$create_response"
      )"
      ((created += 1))
      echo "  CREATED: $new_record_id"
    else
      echo "  ERROR: failed to create record" >&2
      ((failed += 1))
    fi
  fi
done <"$INPUT_FILE"

echo
echo "=========================================="
echo " Airtable IP Intelligence Sync Complete"
echo "=========================================="
echo " Date:     $TODAY"
echo " Created:  $created"
echo " Updated:  $updated"
echo " Failed:   $failed"
echo "=========================================="
