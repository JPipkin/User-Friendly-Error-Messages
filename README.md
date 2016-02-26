Displays user-friendly messages when apex throws an exception.

Custom setting "FriendlyMessages__c" controls what is displayed to the user in the Salesforce UI

*** USAGE ***

On DML calls in Apex, use try/catch blocks to catch the exception instance
FOR TRIGGER CONTEXT:
<code>
try{\n
	insert newAccount;\n
}\n
catch(Exception e){\n
	FriendlyErrorException fee = new FriendlyErrorException(Trigger.new, e);\n
    fee.throwIt();\n
}\n
</code>

OUTSIDE TRIGGER CONTEXT:
<code>
try{\n
	insert newAccount;\n
}\n
catch(Exception e){\n
	FriendlyErrorException fee = new FriendlyErrorException(new SObject[] {newAccount}, e);\n
    fee.throwIt();\n
}
</code>

VISUALFORCE PAGE
<code>
try{\n
	insert newAccount;\n
}\n
catch(Exception e){\n
	FriendlyErrorException fee = new FriendlyErrorException(new SObject[] {newAccount}, e);\n
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, fee.my_exception.display));\n
}
</code>