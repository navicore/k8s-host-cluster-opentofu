#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <domain> <subdomain> <ingress-ip>"
  echo "Example: $0 navicore.tech my-vcluster 203.0.113.42"
  exit 1
fi

# Assign arguments to variables
DOMAIN="$1"
SUBDOMAIN="$2"
INGRESS_IP="$3"

# Full domain for the vCluster
FULL_DOMAIN="${SUBDOMAIN}.${DOMAIN}"

# Check if the DNS record already exists
EXISTING_RECORD=$(doctl compute domain records list "$DOMAIN" --output json | jq -r ".[] | select(.name==\"$SUBDOMAIN\" and .type==\"A\")")

if [ -n "$EXISTING_RECORD" ]; then
  echo "DNS record for ${FULL_DOMAIN} already exists."
else
  # Create the A record
  echo "Creating A record for ${FULL_DOMAIN} pointing to ${INGRESS_IP}..."
  doctl compute domain records create "$DOMAIN" --record-type "A" --record-name "$SUBDOMAIN" --record-data "$INGRESS_IP" --record-ttl "300"
  echo "A record created successfully!"
fi
