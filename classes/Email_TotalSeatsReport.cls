global class Email_TotalSeatsReport implements Schedulable{
  
   	global void execute(SchedulableContext  SC){
   		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
	    mail.setHtmlBody(htmlBody());
	    mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
	    //mail.setToAddresses(new list<string>{'emil.somekh@solidcam.com','eddie.pevzner@solidcam.com','natalie.somekh@solidcam.com','david.somekh@solidcam.com'});
	    mail.setSubject('SolidCAM seats summary report');
	    Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
	    return;
    }
    
    private string htmlBody(){
    	CTRL_TotalSeatsReport ctrl = new CTRL_TotalSeatsReport();
   		string tableBody = '';
   		Integer i = 0;
   		for(CTRL_TotalSeatsReport.Reseller row : ctrl.resellers){
   			tableBody += '<tr '+((Math.mod(i++,2) == 0)?'':'style="background:#ddd9c4"')+'>'+
   							'<td><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+row.reseller.Id+'">'+row.reseller.Name+'</a></td>'+
   							'<td align="center">'+row.nbOfSeats.format()+'</td>'+
   							'<td align="center">'+row.nbSolidWorksSeats.format()+'</td>'+
   							'<td align="center">'+row.nbInventorSeats.format()+'</td>'+
   							'<td align="center">'+row.nbSeatXpress.format()+'</td>'+
   							'<td align="center">'+row.nbSeatAFRM.format()+'</td>'+
   							'<td align="center">'+row.nbHSMSeats.format()+'</td>'+
   							'<td align="center">'+row.nbSim5xSeats.format()+'</td>'+
   							'<td align="center">'+row.nbHSSSeats.format()+'</td>'+
   							'<td align="center">'+row.nbSeatTurning.format()+'</td>'+
   							'<td align="center">'+row.nbSeatProbe.format()+'</td>'+
   							'<td align="center">'+row.nbIMachining2DSeats.format()+'</td>'+
   							'<td align="center">'+row.getIMachining2DPerc().setscale(2)+'</td>'+
   							'<td align="center">'+row.nbIMachining3DSeats.format()+'</td>'+
   							'<td align="center">'+row.getIMachining3DPerc().setscale(2)+'</td>'+
   							'<td align="center">'+row.nbSeatsOnSubscription.format()+'</td>'+
   							'<td align="center">'+row.getSubscriptionPerc().setscale(2)+'</td>'+
   						 '</tr>';
   		}/*
   		string totalRow = '<tr bgcolor="#00CCFF">'+
   							'<td>Grand Total ('+ctrl.total.nbRecords+((ctrl.total.nbRecords > 1)? ' Records)</td>' : ' Record)</td>')+
   							'<td align="center">'+ctrl.total.nbOfSeats.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbSolidWorksSeats.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbInventorSeats.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbSeatXpress.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbSeatAFRM.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbHSMSeats.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbSim5xSeats.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbHSSSeats.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbSeatTurning.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbSeatProbe.format()+'</td>'+
   							'<td align="center">'+ctrl.total.nbIMachining2DSeats.format()+'</td>'+
   							'<td align="center">'+ctrl.total.getIMachining2DPerc().setscale(2)+'</td>'+
   							'<td align="center">'+ctrl.total.nbIMachining3DSeats.format()+'</td>'+
   							'<td align="center">'+ctrl.total.getIMachining3DPerc().setscale(2)+'</td>'+
   							'<td align="center">'+ctrl.total.nbSeatsOnSubscription.format()+'</td>'+
   							'<td align="center">'+ctrl.total.getSubscriptionPerc().setscale(2)+'</td>'+
   						 '</tr>';
   						 
   						 
   						 
   		string returnValue = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/VF_TotalSeatsReport">Open report in SalesForce</a>'+
   							 '<table cellspacing="0" cellpadding="2" border="1" style="color: black; font-family: Calibri,sans-serif!important;">'+
					           '<thead>'+
					           	   '<tr bgcolor="#8DB4E2">'+	
						           	  '<th>Reseller</th>'+
					                  '<th>Seats</th>'+
					                  '<th>SolidWorks</th>'+
					                  '<th>Inventor</th>'+
					                  '<th>Xpress</th>'+
					                  '<th>AFRM</th>'+
					                  '<th>HSM</th>'+
					                  '<th>Sim 5x</th>'+
					                  '<th>HSS</th>'+
					                  '<th>Turning</th>'+
					                  '<th>Probe</th>'+
					                  '<th>iMachining 2D</th>'+
					                  '<th>iMachining 2D %</th>'+
					                  '<th>iMachining 3D</th>'+
					                  '<th>iMachining 3D %</th>'+
					                  '<th>Subscription</th>'+
					                  '<th>Subscription %</th>'+
					              '</tr>'+
					          '</thead>'+
					       '<tbody>'+
					       		totalRow+
					       		tableBody+
					       		totalRow+
					       '</tbody>'+
					  '</table>';*/
				
		//string returnValue = '<html>Test mail</html>';
							  
		return tableBody;
    }
}