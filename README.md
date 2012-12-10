FlowProcessMultiSelectChoices
===================

Flow Sample to show how you can process through a multi-select choices in a loop. It includes a utility class
called ListHelper which is used in a loop to process each selected multi-select choice.
The use case is to update the Service Date of individual line item for an opportunity depending on the prodcut code.
The flow shows a simple example of adjusting the service data for 2 Product Codes - iPAD32 and iPHONE5B64 by adding 31
and 60 days respectively.


Contents of the pack
-----------------------------------------
1. Apex class called "ListHelper" which parses a multi-select choice answer to return the first value selected
2. 2 Custom Fields on the Opportunity Line Item object used by the Flow
3. Flow to show how you can use the ListHelper class in a loop to process each multi-select choice and apply logic pertinent
   to each line item


Instructions( When using Salesforce Ant)
-----------------------------------------
1. Get the package
2. Modify the build.properties file to point to your salesforce instance
3. run 'ant deployUnpackaged'
4. Run the flow by going to the Visualforce Page http://<instance URL>/apex/takeMetoAccount


Instructions( When NOT using Salesforce Ant)
-----------------------------------------
1. Get the package
2. Create the Apex class listed in the package manually.
3. Create the custom fields on the opportunity line item object manually.
4. Use the IDE or any other MD API based tool to create the Flow includes in this package

