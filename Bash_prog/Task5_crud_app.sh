#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task5_crud_app.sh
# @author       Sidik Barra Mohammed Awal
# @index        4196524
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  A menu-driven phonebook application for creating,
#               viewing, searching, updating, and deleting contacts.
# @date         14/09/2026
# -----------------------------------------------------------------

DATA_FILE="phonebook.txt"

# Display instructions for the application.
usage() {
  echo "Usage: $0"
  echo "  Run without arguments to start the phonebook."
  echo "  Use -h or --help to display this help."
}

# Create the data file if it is not available.
if [[ ! -f "$DATA_FILE" ]]; then
  if touch "$DATA_FILE"; then
    echo "Created phonebook data file."
  else
    echo "Error: Could not create $DATA_FILE." >&2
    exit 1
  fi
fi

# Add a new contact to the phonebook.
add_contact() {
  echo
  echo "----- ADD CONTACT -----"

  read -r -p "Name: " name
  if [[ -z "$name" ]]; then
    echo "Error: Name cannot be empty."
    return 1
  fi

  read -r -p "Phone number: " phone
  if [[ -z "$phone" ]]; then
    echo "Error: Phone number cannot be empty."
    return 1
  fi

  read -r -p "Email: " email
  if [[ -z "$email" ]]; then
    echo "Error: Email cannot be empty."
    return 1
  fi

  # Give the new contact the next available ID.
  if [[ -s "$DATA_FILE" ]]; then
    last_id=$(tail -n 1 "$DATA_FILE" | cut -d',' -f1)

    if [[ "$last_id" =~ ^[0-9]+$ ]]; then
      new_id=$((last_id + 1))
    else
      echo "Error: Data file contains an invalid ID." >&2
      return 1
    fi
  else
    new_id=1
  fi

  if printf "%s,%s,%s,%s\n" "$new_id" "$name" "$phone" "$email" >> "$DATA_FILE"; then
    echo "Contact added successfully. ID: $new_id"
    return 0
  else
    echo "Error: Contact could not be saved." >&2
    return 1
  fi
}

# Display all contacts.
list_contacts() {
  echo
  echo "----- PHONEBOOK -----"

  if [[ ! -s "$DATA_FILE" ]]; then
    echo "There are no contacts in the phonebook."
    return 0
  fi

  printf "%-5s %-20s %-18s %-30s\n" "ID" "NAME" "PHONE" "EMAIL"
  echo "--------------------------------------------------------------------------"

  while IFS=',' read -r id name phone email; do
    printf "%-5s %-20s %-18s %-30s\n" "$id" "$name" "$phone" "$email"
  done < "$DATA_FILE"

  return 0
}

# Search for a contact using a name or phone number.
find_contact() {
  echo
  echo "----- SEARCH CONTACT -----"

  read -r -p "Enter name or phone number: " keyword

  if [[ -z "$keyword" ]]; then
    echo "Error: Search value cannot be empty."
    return 1
  fi

  if grep -i "$keyword" "$DATA_FILE"; then
    echo "Search completed."
  else
    echo "No matching contact was found."
  fi

  return 0
}

# Update a contact.
edit_contact() {
  echo
  echo "----- UPDATE CONTACT -----"

  read -r -p "Enter contact ID: " id

  if [[ -z "$id" ]]; then
    echo "Error: Contact ID cannot be empty."
    return 1
  fi

  if ! grep -q "^$id," "$DATA_FILE"; then
    echo "No contact was found with ID $id."
    return 0
  fi

  read -r -p "New name: " name
  if [[ -z "$name" ]]; then
    echo "Error: Name cannot be empty."
    return 1
  fi

  read -r -p "New phone number: " phone
  if [[ -z "$phone" ]]; then
    echo "Error: Phone number cannot be empty."
    return 1
  fi

  read -r -p "New email: " email
  if [[ -z "$email" ]]; then
    echo "Error: Email cannot be empty."
    return 1
  fi

  # Always create a backup before changing the existing data.
  if cp "$DATA_FILE" "$DATA_FILE.bak"; then
    echo "Backup created before update."
  else
    echo "Error: Backup failed. Update cancelled." >&2
    return 1
  fi

  updated="$id,$name,$phone,$email"

  if sed -i "s/^$id,.*/$updated/" "$DATA_FILE"; then
    echo "Contact updated successfully."
  else
    echo "Error: Could not update the contact." >&2
    return 1
  fi

  return 0
}

# Delete a contact.
remove_contact() {
  echo
  echo "----- DELETE CONTACT -----"
  read -r -p "Enter contact ID: " id

  if [[ -z "$id" ]]; then
    echo "Error: Contact ID cannot be empty."
    return 1
  fi

  if ! grep -q "^$id," "$DATA_FILE"; then
    echo "No contact was found with ID $id."
    return 0
  fi

  read -r -p "Delete contact $id? Enter y to confirm: " confirmation

  if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
    echo "Delete operation cancelled."
    return 0
  fi

  # Back up the file before deleting anything.
  if cp "$DATA_FILE" "$DATA_FILE.bak"; then
    echo "Backup created before deletion."
  else
    echo "Error: Backup failed. Delete cancelled." >&2
    return 1
  fi

  if sed -i "/^$id,/d" "$DATA_FILE"; then
    echo "Contact deleted successfully."
  else
    echo "Error: Could not delete the contact." >&2
    return 1
  fi

  return 0
}

# Process the help option.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# The program should not receive normal arguments.
if [[ $# -ne 0 ]]; then
  echo "Error: No arguments are required." >&2
  usage
  exit 1
fi

# Main application menu.
while true; do
  echo
  echo "=============================="
  echo "         PHONEBOOK"
  echo "=============================="
  echo "1. Add Contact"
  echo "2. View Contacts"
  echo "3. Search Contact"
  echo "4. Update Contact"
  echo "5. Delete Contact"
  echo "6. Exit"
  echo "=============================="

  read -r -p "Select an option: " option

  case "$option" in
    1)
      add_contact
      ;;
    2)
      list_contacts
      ;;
    3)
      find_contact
      ;;
    4)
      edit_contact
      ;;
    5)
      remove_contact
      ;;
    6)
      echo "Thank you for using the phonebook."
      exit 0
      ;;
    *)
      echo "Error: Invalid option. Please select 1 to 6."
      ;;
  esac
done