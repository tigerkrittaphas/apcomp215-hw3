# Homework 3: Creating a Containerized API Endpoint

**Objective**
Your task is to create a Docker container that will host an API endpoint. This will involve writing a Dockerfile, building the Docker image, and running a Docker container.

**Instructions**

**Create a Containerized Components & Virtual Environment** 

- Create a Containerized Python Environment using uv
- Install `uvicorn` and `fastapi`
- Container needs to expose port `9000`
- When running the container `http://localhost:9000` should be reachable from the host computer 


**Write a Python API Script** 

- Create a folder called `api` and add a python file called `service.py`
- Using FastAPI build the following APIs:
    - Q1: Build a API route `/q1`
        - The route needs to accept `get` requests
        - The route should take in two query parameters `x` and `y`
        - Return the value `math.sqrt(x**2 + y**2)`
    - Q2: Build a API route `/q2`
        - The route needs to accept `post` requests
        - The route should take as an argument json_data which will be dict
        - The json_data will looks like `{ "text":"Hello", "repeat":5}`
        - Return the value = the `text` value repeated `repeat` times with a " "(space) as delimiter.

**Submission Files** 

Your submission repo should have the following files:

```
   |-student-name-hw3
     |-api
       |-service.py
     |-docker-entrypoint.sh
     |-docker-shell.sh
     |-Dockerfile
     |-pyproject.toml
     |-uv.lock
```

**Testing**
Create a file called `test.sh` with the following content:

```
#!/bin/bash

# Base URL for the API
BASE_URL="http://localhost:9000"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Q1: Function to test GET endpoint
test_get() {
    echo "Testing GET /q1..."
    x=3
    y=4
    answer=5.0
    response=$(curl -s -w "\n%{http_code}" "${BASE_URL}/q1?x=${x}&y=${y}")
    status_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ $status_code -eq 200 ]; then
        echo -e "${GREEN}✓ GET /q1 succeeded (Status: ${status_code})${NC}"
        echo "Response body: $body"
        if [ $body = $answer ]; then
            echo -e "${GREEN}✓ GET /q1 answer is correct ${NC}"
        else
            echo -e "${RED}✗ GET /q1 answer is wrong ${NC}"
        fi
    else
        echo -e "${RED}✗ GET /q1 failed (Status: ${status_code})${NC}"
        echo "Response body: $body"
        exit 1
    fi
}

# Q2: Function to test POST endpoint
test_post() {
    echo "Testing POST /q2..."
    text="Hello"
    repeat=5
    json_data="{\"text\":\"$text\",\"repeat\":$repeat}"
    response=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/q2)
    response=$(curl -s -w "\n%{http_code}" \
            -X POST \
            -H "Content-Type: application/json" \
            -d "$json_data" \
            ${BASE_URL}/q2)
    status_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ $status_code -eq 200 ]; then
        echo -e "${GREEN}✓ POST /q2 succeeded (Status: ${status_code})${NC}"
        echo "Response body: $body"
    else
        echo -e "${RED}✗ POST /q2 failed (Status: ${status_code})${NC}"
        echo "Response body: $body"
        exit 1
    fi
}

# Main execution
echo "Starting API tests..."
test_get
echo "-------------------"
test_post
echo "-------------------"
echo -e "${GREEN}All tests completed successfully!${NC}"
```

You can test your work using the `test.sh`. Just run `test.sh` from your host computer and you should not receive any errors.

**Submission**

- Submit your zipped folder (`student-name-hw3`) with above code files to Canvas
