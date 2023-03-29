#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICE_LIST() {
  echo -e "1) haircut\n2) restyle\n3) recolour"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
  
  1) SERVICE 1 ;;
  2) SERVICE 2 ;;
  3) SERVICE 3 ;;
  *) SERVICE_LIST ;;
  esac
}

SERVICE() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  echo $SERVICE_NAME
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "Could we please have your name: "
    read CUSTOMER_NAME
    CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nPlease give us a time for your appointment:"
  read SERVICE_TIME
  NEW_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo "I have put you down for a $(echo $SERVICE_NAME|sed -E 's/^ *|$ *//') at $(echo $SERVICE_TIME|sed -E 's/^ *|$ *//'), $(echo $CUSTOMER_NAME|sed -E 's/^ *|$ *//')."
}

SERVICE_LIST