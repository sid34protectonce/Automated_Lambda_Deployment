#!/bin/bash

echo "This is multi-lambda deployment"
echo "Enter number of lamdas which you want to deploy"

read n

echo "how many types of endpoints you want to hit"

temp=$n
valid_methods=("GET" "POST" "PUT" "DELETE")
declare -a lamda_info

while [ $temp -gt 0 ]; do
    echo "Enter endpoint name:"
    read name
    if ! [[ " ${valid_methods[@]} " =~ " ${name} " ]]; then
        echo "Invalid endpoint name. Please enter a valid REST API method"
        continue
    fi
    echo "Enter number of functions for $name:"
    read number

    temp=$(expr $temp - $number)

    if [ $temp -le 0 ]; then
        echo "As temp has reached 0 or less than 0"
        if [ $temp -eq 0 ]; then
            break
        else
            echo "Modifying the number"
            number=$((number + temp))
            temp=0
        fi
    fi

    lamda_info+=("$name $number")
    echo "Remaining number: $temp"
done

echo "Provided data"
for lamda_info in "${lamda_info[@]}"; do
    echo "$lamda_info"
done

cd ./multilamda

if [ "$(pwd)" = "/path/to/directory" ]; then
    echo "You are in the specified directory."
else
    echo "You are not in the specified directory."
fi

echo "Writing lamda functions in index.js file"

echo "Writing serverless.yml file"

# sls deploy