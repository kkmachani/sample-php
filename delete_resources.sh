#! /bin/bash

AZURE_APP_SERVICE_PLAN="kkasp"
AZURE_APP_SERVICE_NAME="kkphp"
SLOT_NAME="staging"
RESOURCE_GROUP="KK_RG"

# prompt for approval

echo "The Following resources are to be deleted:"
echo "1. App Service: $AZURE_APP_SERVICE_NAME"
echo "2. App Service plan: $AZURE_APP_SERVICE_PLAN"
echo "3. Deployment slot: $SLOT_NAME"

read -p "Are you sure you want to delete the resources? (yes/no): " CONFIRMATION
sleep 10
if [[ "$CONFIRMATION" != "yes" ]]; then

  echo "Executing deletion..."
  exit 0
fi

echo "Deleting the resources..."

echo "Stopping the Deployment slot....."
az webapp deployment slot stop --name $AZURE_APP_SERVICE_NAME --slot $SLOT_NAME  --resource-group $RESOURCE_GROUP
sleep 5
echo "Checking the status of the deployment slot"
az webapp show --name $AZURE_APP_SERVICE_NAME --resource-group $RESOURCE_GROUP --query "deploymentSlots[?name=='$SLOT_NAME'].{name:name, state:state}"
sleep 5
echo "Deleting the Deployment slots..."
az webapp deployment slot delete --name $AZURE_APP_SERVICE_NAME --slot $SLOT_NAME --resource-group $RESOURCE_GROUP


echo "Stoppping the App Service..."
az webapp stop --name $AZURE_APP_SERVICE_NAME --resource-group $RESOURCE_GROUP
sleep 5
echo "Checking the App service status"
az webapp show --name $AZURE_APP_SERVICE_NAME --resource-group $RESOURCE_GROUP --query "state"
sleep 5
echo "Deleting the App Service..."
az webapp delete --name $AZURE_APP_SERVICE_NAME --resource-group $RESOURCE_GROUP
echo "Deleting the App Service Plan"
az appservice plan delete --name $AZURE_APP_SERVICE_PLAN --resource-group $RESOURCE_GROUP

echo "Deleted all the resources Successfully"










