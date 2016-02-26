Displays user-friendly messages when apex throws an exception.

Custom setting "FriendlyMessages__c" controls what is displayed to the user in the Salesforce UI

*** USAGE ***

On DML calls in Apex, use try/catch blocks to catch the exception instance
FOR TRIGGER CONTEXT:
<code>
try{
	insert newAccount;
}
catch(Exception e){
	FriendlyErrorException fee = new FriendlyErrorException(Trigger.new, e);
    fee.throwIt();
}
</code>

OUTSIDE TRIGGER CONTEXT:
<code>
try{
	insert newAccount;
}
catch(Exception e){
	FriendlyErrorException fee = new FriendlyErrorException(new SObject[] {newAccount}, e);
    fee.throwIt();
}
</code>

VISUALFORCE PAGE"
<code>
try{
	insert newAccount;
}
catch(Exception e){
	FriendlyErrorException fee = new FriendlyErrorException(new SObject[] {newAccount}, e);
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, fee.my_exception.display));
}
</code>