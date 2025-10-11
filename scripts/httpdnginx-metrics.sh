#!/bin/bash

APACHE_LOG="/var/log/apache2/access.log"
NGINX_LOG="/var/log/nginx/access.log"

LOG_FILE="/tmp/combined_access.log"
cat "$APACHE_LOG" "$NGINX_LOG" > "$LOG_FILE"

print_results() {
  label="$1"
  count="$2"
  printf "%-25s %s\n" "$label:" "$count"
}
echo "**Unified Website Log Analysis Report (Apache + Nginx)**"

total_hits=$(awk '{print $1}' "$LOG_FILE" | wc -l)
print_results "Total Website Hits" "$total_hits"

unique_visitors=$(awk '{print $1}' "$LOG_FILE" | sort | uniq | wc -l)
print_results "Unique Visitors" "$unique_visitors"

top_pages=$(awk '{if ($7 !~ /\.(jpg|png|gif|css|js|ico|svg)$/) print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5)
echo -e "\nTop 5 Most Requested Pages:"
echo "-------------------------"
echo "$top_pages"
echo "-------------------------"
status_codes=$(awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr)
echo -e "\nCommon HTTP Status Codes:"
echo "-------------------------"
echo "$status_codes"
echo "-------------------------"
server_errors=$(awk '{if ($9 ~ /^5/) print $9, $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 20)
echo -e "\nServer-Side Errors (status + path):"
echo "-------------------------"
echo "$server_errors"
echo "-------------------------"

total_server_errors=$(awk '{if ($9 ~ /^5/) print $9}' "$LOG_FILE" | wc -l)
print_results "Total 5xx Errors" "$total_server_errors"

echo -e "\nLog analysis script complete."