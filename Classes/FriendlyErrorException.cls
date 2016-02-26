/* Class:       FriendlyErrorMessage
 * Created On:  2/23/2016
 * Created by:  OpFocus Team
 * Description: Parse Apex exceptions to make them more end user-friendly
 */
 
public class FriendlyErrorException extends Exception  {

	public String sfdc_error_type;
	public Boolean isUserValidation;
	public MyFriendlyMessage my_exception;
	public String queryString;
	public List<SObject> lstTrigger;

	private static final Map<String,FriendlyMessages__c> messageMap = FriendlyMessages__c.getAll();

	public FriendlyErrorException(List<SObject> lstTr){
		this.lstTrigger = lstTr;
	}

	public void init_Message(Exception ex){
		sfdc_error_type = ex.getTypeName().replace('.','');
		String className = 'FriendlyErrorException.My' + sfdc_error_type;
		FriendlyErrorMessageInterface intf;
		Type t = Type.forName(className);
		if(t != null){
			intf = (FriendlyErrorMessageInterface)t.newInstance();
		}
		else{
			intf = (FriendlyErrorMessageInterface)Type.forName('FriendlyErrorException.MyGeneral').newInstance();
		}
		my_exception = intf.getExceptionInfo(ex);

	}

	public void throwIt(){
		if(lstTrigger.size() > 1 && System.isFuture()){
			throw new FriendlyException();
		}
		else{
			system.debug(LoggingLevel.ERROR,'====> about to throw custom err: ' + JSON.serializePretty(my_exception));
			lstTrigger[0].addError(my_exception.display);
		}
	}

	
	private static String getTheId(String m){
		String rs;
		Integer i = m.indexOf('with id');
		if(i>-1){
			i += 8;
			rs = m.substring(i,i+18);
		}
		return rs;
	}

	private static String getObjectNameFromId(Id oid){
		if(oid==null){
			return 'UNKNOWN';
		}
		return oid.getSobjectType().getDescribe().getLabel();
	}

	public class MySystemDmlException extends Exception implements FriendlyErrorMessageInterface{
		public MyFriendlyMessage getExceptionInfo(Exception ex){
			MyFriendlyMessage myex = new MyFriendlyMessage();
			myex.msg = ex.getMessage();
			myex.line_number = ex.getLineNumber();
			myex.stack_trace = ex.getStackTraceString();
			myex.ex_type = ex.getTypeName();
			myex.error_id = getTheId(myex.msg);
			myex.error_object = getObjectNameFromId(myex.error_id);
			if(myex.msg.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION') > - 1){
				String[] lstMsg1 = myex.msg.split('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
				String[] lstMsg2 = lstMsg1[1].split(':');
				myex.validation_error= lstMsg2[0].trim();
				myex.validation_field = lstMsg2[1].trim();
				myex.display = ' ' + messageMap.get('FIELD_CUSTOM_VALIDATION_EXCEPTION').Friendly_Message__c + ' ';
				myex.display += (myex.validation_field=='[]'?'':'on '+ myex.error_object + ' field ' +myex.validation_field + ', ');
				myex.display += myex.validation_error;
			}
			else if(myex.msg.indexOf('REQUIRED_FIELD_MISSING') > - 1){
				myex.display = ' ' +  messageMap.get('REQUIRED_FIELD_MISSING').Friendly_Message__c + ' ';
				String msg1 = myex.msg.split('Required fields are missing:')[1].trim();
				myex.display += msg1.split(':')[0].trim();
			}
			else if(myex.msg.indexOf('ENTITY_IS_DELETED') > -1){
				myex.display = ' ' +  messageMap.get('ENTITY_IS_DELETED').Friendly_Message__c.replace('{{object}}',myex.error_object);
				myex.display += ' id = ' + myex.error_id;
			}
			else if(myex.msg.indexOf('UNABLE_TO_LOCK_ROW') > -1){
				myex.display = ' ' +  messageMap.get('UNABLE_TO_LOCK_ROW').Friendly_Message__c;
				myex.display += ' id = ' + myex.error_id;
			}
			//TODO: DUPLICATE_VALUE
			else{
				myex.display = ' ' +  messageMap.get('General').Friendly_Message__c;
			}

			system.debug(LoggingLevel.ERROR,'======>>\n' + JSON.serializePretty(myex));
			return myex;
		}
	}


	public class MySystemNullPointerException extends Exception implements FriendlyErrorMessageInterface{
		public MyFriendlyMessage getExceptionInfo(Exception ex){
			MyFriendlyMessage myex = new MyFriendlyMessage();
			myex.msg = ex.getMessage();
			myex.line_number = ex.getLineNumber();
			myex.stack_trace = ex.getStackTraceString();
			myex.ex_type = ex.getTypeName();
			myex.error_id = getTheId(myex.msg);
			myex.display = ' ' + messageMap.get('Attempt to de-reference a null object').Friendly_Message__c.toUpperCase() + ' ';
			myex.display += myex.stack_trace;
			system.debug(LoggingLevel.ERROR,'======>>\n' + JSON.serializePretty(myex));
			return myex;
		}
	}

	public class MySystemSObjectException extends Exception implements FriendlyErrorMessageInterface{
		public MyFriendlyMessage getExceptionInfo(Exception ex){
			MyFriendlyMessage myex = new MyFriendlyMessage();
			myex.msg = ex.getMessage();
			myex.line_number = ex.getLineNumber();
			myex.stack_trace = ex.getStackTraceString();
			myex.ex_type = ex.getTypeName();
			myex.error_id = getTheId(myex.msg);
			if(myex.msg.indexOf('SObject row was retrieved via SOQL') > -1){
				myex.display = ' ' + messageMap.get('SObject row was retrieved via SOQL').Friendly_Message__c.toUpperCase() + ' ';
				myex.display += myex.msg.split('field: ')[1].trim() + ' --- ';
				myex.display += myex.stack_trace;
			}
			system.debug(LoggingLevel.ERROR,'======>>\n' + JSON.serializePretty(myex));
			return myex;
		}
	}

	public class MyGeneral implements FriendlyErrorMessageInterface{
		public MyFriendlyMessage getExceptionInfo(Exception ex){
			MyFriendlyMessage myex = new MyFriendlyMessage();
			myex.msg = ex.getMessage();
			myex.line_number = ex.getLineNumber();
			myex.stack_trace = ex.getStackTraceString();
			myex.ex_type = ex.getTypeName();
			myex.error_id = getTheId(myex.msg);
			myex.display = ' ' + messageMap.get('General').Friendly_Message__c + ' ';
			
			system.debug(LoggingLevel.ERROR,'======>>\n' + JSON.serializePretty(myex));
			return myex;
		}
	}
}