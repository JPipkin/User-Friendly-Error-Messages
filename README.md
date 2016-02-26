Displays user-friendly messages when apex throws an exception.

Custom setting "FriendlyMessages__c" controls what is displayed to the user in the Salesforce UI

*** USAGE ***

On DML calls in Apex, use try/catch blocks to catch the exception instance
FOR TRIGGER CONTEXT:
<i>
try{
	insert newAccount;
}
catch(Exception e){
	FriendlyErrorException fee = new FriendlyErrorException(Trigger.new, e);
    fee.throwIt();
}
</i>

OUTSIDE TRIGGER CONTEXT:
<i>
try{
	insert newAccount;
}
catch(Exception e){
	FriendlyErrorException fee = new FriendlyErrorException(new SObject[] {newAccount}, e);
    fee.throwIt();
}
</i>

VISUALFORCE PAGE
<i>
try{
	insert newAccount;
}
catch(Exception e){
	FriendlyErrorException fee = new FriendlyErrorException(new SObject[] {newAccount}, e);
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, fee.my_exception.display));
}
</i>