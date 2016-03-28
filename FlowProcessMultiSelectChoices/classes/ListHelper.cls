/*

Copyright (c) 2012, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, 
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors 
    may be used to endorse or promote products derived from this software 
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
OF THE POSSIBILITY OF SUCH DAMAGE.


This is a Flow Plug-in class which is itended to help the flow designer process
indivudial choices selected from a multi-select choice in a flow.

The class gets the first choice from the choice value and returns the remainder
choices along with a boolean flag to let the user know if the current choice 
is the last one.

* Inputs
*    inputList (String): Multi-select choice Stored Value ( a ';' separeted choice value set)
* Outputs
*    nextItem (String): A single choice from the list provided
*    remainderList (String): Remainder of the list 
*    lastItem (Boolean): Boolean flag to indicate if the item returned was the last one

*/

global class ListHelper implements Process.Plugin{

    public String nextItem;
    public String remainderList;
    public Boolean lastItem;

    
    global Process.PluginResult invoke(Process.PluginRequest request) {    

        String inputList = (String) request.inputParameters.get('inputList');
        inputList = inputList.removeStart('[');
        inputList = inputList.removeEnd(']');
        Map<String,Object> result = new Map<String,Object>();
        if (inputList==null || inputList=='') {
            result.put('nextItem', null);
            result.put('remainderList', null);
            result.put('lastItem', true);            
            return new Process.PluginResult(result); 
                 
        }
        
        BreakdownList(inputList);
        result.put('nextItem', nextItem);
        result.put('remainderList', remainderList);
        result.put('lastItem', lastItem);            
     
        return new Process.PluginResult(result); 
    }
    
    global Process.PluginDescribeResult describe() {
    
    Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description = 'The ListHelper classes is used as an iterator where it accepts a list and outputs 1 of the list and a reminder count.';
        result.tag = 'Utilities';
        
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter('inputList', 
                Process.PluginDescribeResult.ParameterType.STRING, true)                                         
                };

        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
            new Process.PluginDescribeResult.OutputParameter('nextItem', 
                Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('remainderList', 
                Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('lastItem', 
                Process.PluginDescribeResult.ParameterType.BOOLEAN)   
                };
   
        
        return result;
        }
  
    private void BreakdownList(String itemList) {
        Integer firstIndex = itemList.indexOf(';');
        if (firstIndex == -1 ) {
            nextItem = itemList;
            remainderList = null;
            lastItem = true;
            return;
        }
        nextItem = itemList.subStringBefore(';').trim();
        remainderList = itemList.subStringAfter(';').trim();
        lastItem = false;

    }

  
        
    @isTest 
    static void basicTest() {    
        ListHelper aPlugin = new ListHelper();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        //null test
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aPlugin.invoke(request);
        
        System.assertEquals(result.outputparameters.get('nextItem'),null);
        System.assertEquals(result.outputparameters.get('remainderList'),null);
        System.assertEquals(result.outputparameters.get('lastItem'),true);
 
        // with just 1 item       
        inputParams.clear();
        outputParams.clear();        
        inputParams.put('inputList','item1');
        result = aPlugin.invoke(request);
        
        System.assertEquals(result.outputparameters.get('nextItem'),'item1');
        System.assertEquals(result.outputparameters.get('remainderList'),null);
        System.assertEquals(result.outputparameters.get('lastItem'),true);
  
  
        // with  2 items
        inputParams.clear();
        outputParams.clear();                
        inputParams.put('inputList','item1;item2');
        result = aPlugin.invoke(request);
        
        System.assertEquals(result.outputparameters.get('nextItem'),'item1');
        System.assertEquals(result.outputparameters.get('remainderList'),'item2');
        System.assertEquals(result.outputparameters.get('lastItem'),false);

        // with just 3 items
        inputParams.clear();
        outputParams.clear();             
        inputParams.put('inputList','item1;item2;item3');
        result = aPlugin.invoke(request);
        
        System.assertEquals(result.outputparameters.get('nextItem'),'item1');
        System.assertEquals(result.outputparameters.get('remainderList'),'item2;item3');
        System.assertEquals(result.outputparameters.get('lastItem'),false);
        

        // with just 4 items
        inputParams.clear();
        outputParams.clear();             
        inputParams.put('inputList','item1 ;item2; item3; item4');
        result = aPlugin.invoke(request);
        
        System.assertEquals(result.outputparameters.get('nextItem'),'item1');
        System.assertEquals(result.outputparameters.get('remainderList'),'item2; item3; item4');
        System.assertEquals(result.outputparameters.get('lastItem'),false);

    }
    
    @isTest
    static void describeTest() {

        ListHelper aPlugin = new ListHelper();
        Process.PluginDescribeResult result = aPlugin.describe();
                
        System.AssertEquals(result.inputParameters.size(), 1);
        System.AssertEquals(result.OutputParameters.size(), 3);
        
        }

    
}
