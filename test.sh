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