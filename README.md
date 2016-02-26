Displays user-friendly messages when apex throws an exception.

Custom setting "FriendlyMessages__c" controls what is displayed to the user in the Salesforce UI

*** USAGE ***

On DML calls in Apex, use try/catch blocks to catch the exception instance
FOR TRIGGER CONTEXT:
<code>
try{<br/>
	insert newAccount;<br/>
}<br/>
catch(Exception e){<br/>
	FriendlyErrorException fee = new FriendlyErrorException(Trigger.new, e);<br/>
    fee.throwIt();<br/>
}<br/>
</code>

OUTSIDE TRIGGER CONTEXT:
<code>
try{<br/>
	insert newAccount;<br/>
}<br/>
catch(Exception e){<br/>
	FriendlyErrorException fee = new FriendlyErrorException(new SObject[] {newAccount}, e);<br/>
    fee.throwIt();<br/>
}
</code>

VISUALFORCE PAGE"
<code>
try{<br/>
	insert newAccount;<br/>
}<br/>
catch(Exception e){<br/>
	FriendlyErrorException fee = new FriendlyErrorException(new SObject[] {newAccount}, e);<br/>
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, fee.my_exception.display));<br/>
}
</code>