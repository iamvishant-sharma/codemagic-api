#!/bin/bash

API_TOKEN_CODE_MAGIC=$1

# Get APP_ID
APP_ID=$(curl -s -H "Content-Type: application/json" -H "x-auth-token: ${API_TOKEN_CODE_MAGIC}" --request GET https://api.codemagic.io/apps | jq -r '.applications[0]._id')
echo application id: $APP_ID

# Get WORKFLOW_ID
WORKFLOW_ID=$(curl -s -H "Content-Type: application/json" -H "x-auth-token: ${API_TOKEN_CODE_MAGIC}" --request GET https://api.codemagic.io/apps | jq -r '.applications[0].workflowIds[]')
echo workflow id: $WORKFLOW_ID

# Get BRANCH
BRANCH=$(curl -s -H "Content-Type: application/json" -H "x-auth-token: ${API_TOKEN_CODE_MAGIC}" --request GET https://api.codemagic.io/apps | jq -r '.applications[0].branches[]')
echo Branch: $BRANCH

# Create BUILD_ID
BUILD_ID=$(curl -s -H "Content-Type: application/json" -H "x-auth-token: ${API_TOKEN_CODE_MAGIC}" --data '{"appId": "'"${APP_ID}"'","workflowId": "'"${WORKFLOW_ID}"'","branch": "'"${BRANCH}"'"}' https://api.codemagic.io/builds | jq -r .buildId)
echo Build Id: $BUILD_ID

# Get APK_STATUS
APK_STATUS=$(curl -s -H "Content-Type: application/json" -H "x-auth-token: ${API_TOKEN_CODE_MAGIC}" --request GET https://api.codemagic.io/builds/${BUILD_ID} | jq -r '.build.buildActions[] | select(.type == "publishing") | .status')

sleep 140

echo APP Status: $APK_STATUS

# Get APK_URL
APK_URL=$(curl -s -H "Content-Type: application/json" -H "x-auth-token: ${API_TOKEN_CODE_MAGIC}" --request GET https://api.codemagic.io/builds/${BUILD_ID} | jq -r '.build.artefacts[] | select(.type == "app") | .url')
echo App URL: $APK_URL

# Create public URL for APK
DOWNLOAD_APK_URL=$(curl -s -H "Content-Type: application/json" -H "x-auth-token: ${API_TOKEN_CODE_MAGIC}" -d '{"expiresAt": 1715410157}' -X POST "${APK_URL}/public-url" | jq -r .url)

echo Download URL: $DOWNLOAD_APK_URL
