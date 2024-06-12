#!/bin/bash

echo "Log File Analysis Running"

LOG_FILE="access.log"


# Executes only if Log File is in the command line and Log File exists

if [ -z "$1" ]; then
    read -p "Please enter the log file path: " LOG_FILE
else
    LOG_FILE=$1
fi


# Check if File exists

if [[ ! -f $LOG_FILE ]]; then
    echo "File Not Found"
    exit 1
fi

totalrequestscount() {

    # Line Count for total requests
    
    total_requests=$(wc -l < "$LOG_FILE")
    echo "Total Requests Count: $total_requests"

}

successfulrequestcodes() {

    # If response code is between 200-299 -> Successful response

    total_requests=$(wc -l < "$LOG_FILE")
    successful_requests=$(awk '$9 ~ /^[2][0-9][0-9]$/' "$LOG_FILE" | wc -l)

    if [ $total_requests -eq 0 ]; then
        echo "No requests found in the log file."
        break
    fi

    percentage=$(echo "scale=2; ($successful_requests/$total_requests)*100" | bc)
    echo "Percentage of Successful Requests: $percentage%"

}

mostused() {

    # Most Active User based on number of requests per IP

    most_active_user=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 1)
    echo "Most Active User: $most_active_user"
    

}

requestcategory() {

    # Sort by type of request, POST, GET, PUT, DELETE and generate number of each requests done
    echo "HTTP Request Categories:"
    for method in GET POST PUT DELETE; 

    do
        count=$(grep -c "\"$method" "$LOG_FILE")
        echo "$method: $count"
    done

}

# Main Menu
echo " Log Analysis"

echo "Choose the required option:
1. Total Requests Count
2. Percentage of Successful Requests
3. Most Active User
4. HTTP Request Category
5. All metrics
"

# User Input for Menu
read -p "Enter your choice between 1-5: " choice

case $choice in
    1)
        totalrequestscount
        ;;
    2)
        successfulrequestcodes
        ;;
    3)
        mostused
        ;;
    4)
        requestcategory
        ;;
    5)
        totalrequestscount
        successfulrequestcodes
        mostused
        requestcategory
        ;;
    *)
        echo "Wrong Option. Choose between 1-5 "
        ;;

esac
