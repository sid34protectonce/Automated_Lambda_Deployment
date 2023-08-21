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

    if [ $temp -lt 0 ]; then
        echo "As temp has reached 0 or less than 0"
        echo "Modifying the number"
        number=$((number + temp))
        temp=0
    fi

    lamda_info+=("$name $number")
    echo "Remaining number: $temp"
done

# echo "Provided data"
# for lamda_info in "${lamda_info[@]}"; do
#     echo "$lamda_info"
# done

cd ./multilamda

echo "we are in directory $(pwd)"

echo "Writing lamda functions in index.js file"
touch index.js

for lamda_info in "${lamda_info[@]}"; do
    trimmed_info=$(echo "$lamda_info" | tr -d '\r\n')  # Remove newline characters

    func_name=$(echo "$trimmed_info" | cut -d ' ' -f 1)
    count=$(echo "$trimmed_info" | cut -d ' ' -f 2)


    echo "$func_name"
    echo "$count"
    count=$((count))

    for ((i=1; i<=count; i++)); do
        echo "module.exports.$func_name$i = async (event) => {" >> index.js
        echo "  return {" >> index.js
        echo "    statusCode: 200," >> index.js
        echo "    body: JSON.stringify(" >> index.js
        echo "      {" >> index.js
        echo "        message: \"Hello from $func_name$i\"," >> index.js
        echo "        input: event," >> index.js
        echo "      }," >> index.js
        echo "      null," >> index.js
        echo "      2" >> index.js
        echo "    )," >> index.js
        echo "  };" >> index.js
        echo "};" >> index.js
        echo >> index.js
    done
done

# sls deploy