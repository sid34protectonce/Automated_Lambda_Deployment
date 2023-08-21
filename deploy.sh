#!/bin/bash

echo "This is multi-lambda deployment"
echo "Enter number of lamdas which you want to deploy"

read n

echo "Tell me the exact number of methods & number of lambdas needed for it"

temp=$n
valid_methods=("GET" "POST" "PUT" "DELETE")
declare -a lamda_info

while [ $temp -gt 0 ]; do
    echo "Enter method name:"
    read name
    if ! [[ " ${valid_methods[@]} " =~ " ${name} " ]]; then
        echo "Invalid endpoint name. Please enter a valid REST API method"
        continue
    fi
    echo "Enter number of functions for $name:"
    read number

    temp=$(expr $temp - $number)

    if [ $temp -lt 0 ]; then
        number=$((number + temp))
        temp=0
    fi

    lamda_info+=("$name $number")
    echo "Remaining number: $temp"
done

temp_info=("${lamda_info[@]}")

cd ./multilamda

echo "we are in directory $(pwd)"

echo "Writing lamda functions in index.js file"
touch index.js


for lamda_info in "${lamda_info[@]}"; do
    trimmed_info=$(echo "$lamda_info" | tr -d '\r\n')

    func_name=$(echo "$trimmed_info" | cut -d ' ' -f 1)
    count=$(echo "$trimmed_info" | cut -d ' ' -f 2)


    count=$((count))
    echo "$func_name"
    echo "$count"

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

echo "writing serverless.yml file"
touch serverless.yml

cat << EOF > serverless.yml
org: sidd34po
app: multilambda
service: multilambda
frameworkVersion: '3'

provider:
  name: aws
  runtime: nodejs18.x

functions:
EOF

for temp_info_n in "${temp_info[@]}"; do
    temp_var=$temp_info_n
    echo "$temp_var"
    trimmed_info2=$(echo "$temp_var" | tr -d '\r\n')
    func_name1=$(echo "$trimmed_info2" | cut -d ' ' -f 1)
    count1=$(echo "$trimmed_info2" | cut -d ' ' -f 2)
    for ((i=1; i<=count1; i++)); do
        echo "  ${func_name1}${i}:" >> serverless.yml
        echo "    handler: index.${func_name1}${i}" >> serverless.yml
        echo "    events:" >> serverless.yml
        echo "      - http:" >> serverless.yml
        echo "          path: /${func_name1,,}${i}" >> serverless.yml
        echo "          method: ${func_name1,,}" >> serverless.yml
    done
done

# npm install -g serverless

# serverless deploy
