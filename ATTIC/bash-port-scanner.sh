#!/bin/bash
# Bash port scanner
# http://www.catonmat.net/blog/tcp-port-scanner-in-bash/

scan() {
  if [[ -z $1 || -z $2 ]]; then
    echo "Usage: $0 <host> <port, ports, or port-range>"
    return
  fi

  local host=$1
  local ports=()
  case $2 in
    *-*)
      IFS=- read start end <<< "$2"
      for ((port=start; port <= end; port++)); do
        ports+=($port)
      done
      ;;
    *,*)
      IFS=, read -ra ports <<< "$2"
      ;;
    *)
      ports+=($2)
      ;;
  esac


  for port in "${ports[@]}"; do
    alarm 1 "echo >/dev/tcp/$host/$port" &&
      echo "port $port is open" ||
      echo "port $port is closed"
  done
}

scan