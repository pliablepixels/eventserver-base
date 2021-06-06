#!/usr/bin/with-contenv bash
. "/usr/local/bin/logger"
program_name="es-certificate-gen"

if [[ ! -f /config/ssl/cert.cer || ! -f /config/ssl/key.pem ]]; then
  echo "Generating Self-Signed Certificates because ssl/cert.cer or ssl/key.pem does not exist!" | info "[${program_name}] "
  mkdir -p /config/ssl
  openssl req -x509 -nodes -days 4096 -newkey rsa:2048 -keyout /config/ssl/key.pem -out /config/ssl/cert.cer -subj "/CN=${ES_COMMON_NAME}"
else
  echo "Using existing certificates at ssl..." | info "[${program_name}] "
fi

if [[ "${GENERATE_DHPARAM}" -eq "1" ]]; then 
  if [[ ! -f /config/ssl/dhparam.pem ]]; then
    echo "Generating dhparam.pem..." | info "[${program_name}] "
    openssl dhparam -out /config/ssl/dhparam.pem 4096
  else
    echo "Using existing dhparam.pem" | info "[${program_name}] "
  fi
else
  echo "Skipping dhparam.pem generation"
fi
