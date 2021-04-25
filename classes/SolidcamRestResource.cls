@RestResource(urlMapping='/Reseller/*')
global with sharing class SolidcamRestResource {
	public class myException extends Exception {}
	@HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response;
        String stringXml;
     	try{  
        	String ResellerId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        	if(resellerId.equalsIgnoreCase('all')){
        		stringXml = getTop30Resellers();
        	}
	        else if((resellerID InstanceOf Id)){
		        AggregateResult[] results = [Select Reseller__r.Name, Reseller__c, COUNT(ID), SUM(Number_of_seats__c), SUM(SolidWorks_seats__c), SUM(Inventor_seats__c), SUM(HSM_seats__c), SUM(Sim_5x_seats__c), SUM(HSS_seats__c), SUM(iMachining_seats__c), SUM(iMachining3D_seats__c), SUM(Seats_on_subscription__c), SUM(Xpress_seats__c), SUM(AFRM_seats__c), SUM(Turning_seats__c), SUM(Probe_No__c) 
					From Dongle__c                        
					Where Reseller__c =: ResellerId
					Group By Reseller__r.Name, Reseller__c];
				if(results.size() == 0){
					throw new myException('Invalid Id of Reseller');
				}
				
				stringXml = xmlReseller(results[0]);
		        
		        
        	}
        	if(stringXml != null){
	        	response.addHeader('Content-Type', 'text/xml');
		        response.statusCode = 200;
		   		response.responseBody = Blob.valueOf(stringXml);
	        }
	        else{
	        	response.addHeader('Content-Type', 'application/json');
				response.statusCode = 500;
	   			response.responseBody = Blob.valueOf('{"error_code":500, "message":"The xml not created. "}');
	        }
    	}
    	catch(Exception e){
	    	response.addHeader('Content-Type', 'application/json');
			response.statusCode = 500;
		   	response.responseBody = Blob.valueOf('{"error_code":500, "message":"'+e+'"}');
    	}
    }
    
    public static String xmlReseller(AggregateResult result){
	 	CTRL_TotalSeatsReport.Reseller r = new CTRL_TotalSeatsReport.Reseller(result);
    	Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
        xmlW.writeStartElement(null,'Reseller',null);
	        xmlW.writeStartElement(null,'Name',null);
	        xmlW.writeCharacters(r.reseller.Name);
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'Seats',null);
	        xmlW.writeCharacters(r.nbOfSeats.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'SolidWorks',null);
	        xmlW.writeCharacters(r.nbSolidWorksSeats.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'Inventor',null);
	        xmlW.writeCharacters(r.nbInventorSeats.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'Xpress',null);
	        xmlW.writeCharacters(r.nbSeatXpress.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'AFRM',null);
	        xmlW.writeCharacters(r.nbSeatAFRM.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'HSM',null);
	        xmlW.writeCharacters(r.nbHSMSeats.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'Sim5X',null);
	        xmlW.writeCharacters(r.nbSim5xSeats.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'HSS',null);
	        xmlW.writeCharacters(r.nbHSSSeats.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'Turning',null);
	        xmlW.writeCharacters(r.nbSeatTurning.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'Probe',null);
	        xmlW.writeCharacters(r.nbSeatProbe.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'iMachining2D',null);
	        xmlW.writeCharacters(r.nbIMachining2DSeats.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'iMachining2D_Percent',null);
	        xmlW.writeCharacters(String.valueOf(r.getIMachining2DPerc().setscale(2)));
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'iMachining3D',null);
	        xmlW.writeCharacters(r.nbIMachining3DSeats.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'iMachining3D_Percent',null);
	        xmlW.writeCharacters(String.valueOf(r.getIMachining3DPerc().setscale(2)));
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'Subscription',null);
	        xmlW.writeCharacters(r.nbSeatsOnSubscription.format());
	        xmlW.writeEndElement();
	        xmlW.writeStartElement(null,'Subscription_Percent',null);
	        xmlW.writeCharacters(String.valueOf(r.getSubscriptionPerc().setscale(2)));
	        xmlW.writeEndElement();
	    xmlW.writeEndElement();
        xmlW.writeEndDocument();
        return xmlW.getXmlString();
    }
    
    //This function will return the top 30 resellers
    public static string getTop30Resellers(){
    	CTRL_TotalSeatsReport ctrl = new CTRL_TotalSeatsReport();
    	List<CTRL_TotalSeatsReport.Reseller> resellers = ctrl.getTop30Resellers();
    	DOM.Document doc = new DOM.Document();
    	DOM.XmlNode root = doc.createRootElement('Resellers',null,null);
    	for(CTRL_TotalSeatsReport.Reseller reseller:resellers){
    		reseller.addXmlToNode(root);
    	}
    	return doc.toXmlString();
    }
}