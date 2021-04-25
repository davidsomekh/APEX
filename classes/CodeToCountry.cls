/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

global class CodeToCountry {
	
	global Map<String,String> m_CodeMAP;

 
    global CodeToCountry(){
    	
    	m_CodeMAP = new Map<String, String>();
    	
    	m_CodeMAP.put('AF','Afghanistan');
    	m_CodeMAP.put('AX' , 'Aland Islands');
		m_CodeMAP.put('AL' , 'Albania');
		m_CodeMAP.put('DZ' , 'Algeria');
		m_CodeMAP.put('AS' , 'American Samoa');
		m_CodeMAP.put('AD' , 'Andorra');
		m_CodeMAP.put('AO' , 'Angola');
		m_CodeMAP.put('AI' , 'Anguilla');
		m_CodeMAP.put('AQ' , 'Antarctica');
		m_CodeMAP.put('AG' , 'Antigua And Barbuda');
		m_CodeMAP.put('AR' , 'Argentina');
		m_CodeMAP.put('AM' , 'Armenia');
		m_CodeMAP.put('AW' , 'Aruba');
		m_CodeMAP.put('AU' , 'Australia');
		m_CodeMAP.put('AT' , 'Austria');
		m_CodeMAP.put('AZ' , 'Azerbaijan');
		m_CodeMAP.put('BS' , 'Bahamas');
		m_CodeMAP.put('BH' , 'Bahrain');
		m_CodeMAP.put('BD' , 'Bangladesh');
		m_CodeMAP.put('BB' , 'Barbados');
		m_CodeMAP.put('BY' , 'Belarus');
		m_CodeMAP.put('BE' , 'Belgium');
		m_CodeMAP.put('BZ' , 'Belize');
		m_CodeMAP.put('BJ' , 'Benin');
		m_CodeMAP.put('BM' , 'Bermuda');
		m_CodeMAP.put('BT' , 'Bhutan');
		m_CodeMAP.put('BO' , 'Bolivia');
		m_CodeMAP.put('BA' , 'Bosnia And Herzegovina');
		m_CodeMAP.put('BW' , 'Botswana');
		m_CodeMAP.put('BV' , 'Bouvet Island');
		m_CodeMAP.put('BR' , 'Brazil');
		m_CodeMAP.put('IO' , 'British Indian Ocean Territory');
		m_CodeMAP.put('BN' , 'Brunei Darussalam');
		m_CodeMAP.put('BG' , 'Bulgaria');
		m_CodeMAP.put('BF' , 'Burkina Faso');
		m_CodeMAP.put('BI' , 'Burundi');
		m_CodeMAP.put('KH' , 'Cambodia');
		m_CodeMAP.put('CM' , 'Cameroon');
		m_CodeMAP.put('CA' , 'Canada');
		m_CodeMAP.put('CV' , 'Cape Verde');
		m_CodeMAP.put('KY' , 'Cayman Islands');
		m_CodeMAP.put('CF' , 'Central African Republic');
		m_CodeMAP.put('TD' , 'Chad');
		m_CodeMAP.put('CL' , 'Chile');
		m_CodeMAP.put('CN' , 'China');
		m_CodeMAP.put('CX' , 'Christmas Island');
		m_CodeMAP.put('CC' , 'Cocos (Keeling) Islands');
		m_CodeMAP.put('CO' , 'Colombia');
		m_CodeMAP.put('KM' , 'Comoros');
		m_CodeMAP.put('CG' , 'Congo');
		m_CodeMAP.put('CD' , 'Congo Democratic Republic');
		m_CodeMAP.put('CK' , 'Cook Islands');
		m_CodeMAP.put('CR' , 'Costa Rica');
		m_CodeMAP.put('CI' , 'Cote D\'Ivoire');
		m_CodeMAP.put('HR' , 'Croatia');
		m_CodeMAP.put('CU' , 'Cuba');
		m_CodeMAP.put('CY' , 'Cyprus');
		m_CodeMAP.put('CZ' , 'Czech Republic');
		m_CodeMAP.put('DK' , 'Denmark');
		m_CodeMAP.put('DJ' , 'Djibouti');
		m_CodeMAP.put('DM' , 'Dominica');
		m_CodeMAP.put('DO' , 'Dominican Republic');
		m_CodeMAP.put('EC' , 'Ecuador');
		m_CodeMAP.put('EG' , 'Egypt');
		m_CodeMAP.put('SV' , 'El Salvador');
		m_CodeMAP.put('GQ' , 'Equatorial Guinea');
		m_CodeMAP.put('ER' , 'Eritrea');
		m_CodeMAP.put('EE' , 'Estonia');
		m_CodeMAP.put('ET' , 'Ethiopia');
		m_CodeMAP.put('FK' , 'Falkland Islands (Malvinas)');
		m_CodeMAP.put('FO' , 'Faroe Islands');
		m_CodeMAP.put('FJ' , 'Fiji');
		m_CodeMAP.put('FI' , 'Finland');
		m_CodeMAP.put('FR' , 'France');
		m_CodeMAP.put('GF' , 'French Guiana');
		m_CodeMAP.put('PF' , 'French Polynesia');
		m_CodeMAP.put('TF' , 'French Southern Territories');
		m_CodeMAP.put('GA' , 'Gabon');
		m_CodeMAP.put('GM' , 'Gambia');
		m_CodeMAP.put('GE' , 'Georgia');
		m_CodeMAP.put('DE' , 'Germany');
		m_CodeMAP.put('GH' , 'Ghana');
		m_CodeMAP.put('GI' , 'Gibraltar');
		m_CodeMAP.put('GR' , 'Greece');
		m_CodeMAP.put('GL' , 'Greenland');
		m_CodeMAP.put('GD' , 'Grenada');
		m_CodeMAP.put('GP' , 'Guadeloupe');
		m_CodeMAP.put('GU' , 'Guam');
		m_CodeMAP.put('GT' , 'Guatemala');
		m_CodeMAP.put('GG' , 'Guernsey');
		m_CodeMAP.put('GN' , 'Guinea');
		m_CodeMAP.put('GW' , 'Guinea-Bissau');
		m_CodeMAP.put('GY' , 'Guyana');
		m_CodeMAP.put('HT' , 'Haiti');
		m_CodeMAP.put('HM' , 'Heard Island & Mcdonald Islands');
		m_CodeMAP.put('VA' , 'Holy See (Vatican City State)');
		m_CodeMAP.put('HN' , 'Honduras');
		m_CodeMAP.put('HK' , 'Hong Kong');
		m_CodeMAP.put('HU' , 'Hungary');
		m_CodeMAP.put('IS' , 'Iceland');
		m_CodeMAP.put('IN' , 'India');
		m_CodeMAP.put('ID' , 'Indonesia');
		m_CodeMAP.put('IR' , 'Iran Islamic Republic Of');
		m_CodeMAP.put('IQ' , 'Iraq');
		m_CodeMAP.put('IE' , 'Ireland');
		m_CodeMAP.put('IM' , 'Isle Of Man');
		m_CodeMAP.put('IL' , 'Israel');
		m_CodeMAP.put('IT' , 'Italy');
		m_CodeMAP.put('JM' , 'Jamaica');
		m_CodeMAP.put('JP' , 'Japan');
		m_CodeMAP.put('JE' , 'Jersey');
		m_CodeMAP.put('JO' , 'Jordan');
		m_CodeMAP.put('KZ' , 'Kazakhstan');
		m_CodeMAP.put('KE' , 'Kenya');
		m_CodeMAP.put('KI' , 'Kiribati');
		m_CodeMAP.put('KR' , 'Korea');
		m_CodeMAP.put('XK' , 'Kosovo');
		m_CodeMAP.put('KW' , 'Kuwait');
		m_CodeMAP.put('KG' , 'Kyrgyzstan');
		m_CodeMAP.put('LA' , 'Lao People\'s Democratic Republic');
		m_CodeMAP.put('LV' , 'Latvia');
		m_CodeMAP.put('LB' , 'Lebanon');
		m_CodeMAP.put('LS' , 'Lesotho');
		m_CodeMAP.put('LR' , 'Liberia');
		m_CodeMAP.put('LY' , 'Libyan Arab Jamahiriya');
		m_CodeMAP.put('LI' , 'Liechtenstein');
		m_CodeMAP.put('LT' , 'Lithuania');
		m_CodeMAP.put('LU' , 'Luxembourg');
		m_CodeMAP.put('MO' , 'Macao');
		m_CodeMAP.put('MK' , 'Macedonia');
		m_CodeMAP.put('MG' , 'Madagascar');
		m_CodeMAP.put('MW' , 'Malawi');
		m_CodeMAP.put('MY' , 'Malaysia');
		m_CodeMAP.put('MV' , 'Maldives');
		m_CodeMAP.put('ML' , 'Mali');
		m_CodeMAP.put('MT' , 'Malta');
		m_CodeMAP.put('MH' , 'Marshall Islands');
		m_CodeMAP.put('MQ' , 'Martinique');
		m_CodeMAP.put('MR' , 'Mauritania');
		m_CodeMAP.put('MU' , 'Mauritius');
		m_CodeMAP.put('YT' , 'Mayotte');
		m_CodeMAP.put('MX' , 'Mexico');
		m_CodeMAP.put('FM' , 'Micronesia Federated States Of');
		m_CodeMAP.put('MD' , 'Moldova');
		m_CodeMAP.put('MC' , 'Monaco');
		m_CodeMAP.put('MN' , 'Mongolia');
		m_CodeMAP.put('ME' , 'Montenegro');
		m_CodeMAP.put('MS' , 'Montserrat');
		m_CodeMAP.put('MA' , 'Morocco');
		m_CodeMAP.put('MZ' , 'Mozambique');
		m_CodeMAP.put('MM' , 'Myanmar');
		m_CodeMAP.put('NA' , 'Namibia');
		m_CodeMAP.put('NR' , 'Nauru');
		m_CodeMAP.put('NP' , 'Nepal');
		m_CodeMAP.put('NL' , 'Netherlands');
		m_CodeMAP.put('AN' , 'Netherlands Antilles');
		m_CodeMAP.put('NC' , 'New Caledonia');
		m_CodeMAP.put('NZ' , 'New Zealand');
		m_CodeMAP.put('NI' , 'Nicaragua');
		m_CodeMAP.put('NE' , 'Niger');
		m_CodeMAP.put('NG' , 'Nigeria');
		m_CodeMAP.put('NU' , 'Niue');
		m_CodeMAP.put('NF' , 'Norfolk Island');
		m_CodeMAP.put('MP' , 'Northern Mariana Islands');
		m_CodeMAP.put('NO' , 'Norway');
		m_CodeMAP.put('OM' , 'Oman');
		m_CodeMAP.put('PK' , 'Pakistan');
		m_CodeMAP.put('PW' , 'Palau');
		m_CodeMAP.put('PS' , 'Palestinian Territory Occupied');
		m_CodeMAP.put('PA' , 'Panama');
		m_CodeMAP.put('PG' , 'Papua New Guinea');
		m_CodeMAP.put('PY' , 'Paraguay');
		m_CodeMAP.put('PE' , 'Peru');
		m_CodeMAP.put('PH' , 'Philippines');
		m_CodeMAP.put('PN' , 'Pitcairn');
		m_CodeMAP.put('PL' , 'Poland');
		m_CodeMAP.put('PT' , 'Portugal');
		m_CodeMAP.put('PR' , 'Puerto Rico');
		m_CodeMAP.put('QA' , 'Qatar');
		m_CodeMAP.put('RE' , 'Reunion');
		m_CodeMAP.put('RO' , 'Romania');
		m_CodeMAP.put('RU' , 'Russian Federation');
		m_CodeMAP.put('RW' , 'Rwanda');
		m_CodeMAP.put('BL' , 'Saint Barthelemy');
		m_CodeMAP.put('SH' , 'Saint Helena');
		m_CodeMAP.put('KN' , 'Saint Kitts And Nevis');
		m_CodeMAP.put('LC' , 'Saint Lucia');
		m_CodeMAP.put('MF' , 'Saint Martin');
		m_CodeMAP.put('PM' , 'Saint Pierre And Miquelon');
		m_CodeMAP.put('VC' , 'Saint Vincent And Grenadines');
		m_CodeMAP.put('WS' , 'Samoa');
		m_CodeMAP.put('SM' , 'San Marino');
		m_CodeMAP.put('ST' , 'Sao Tome And Principe');
		m_CodeMAP.put('SA' , 'Saudi Arabia');
		m_CodeMAP.put('SN' , 'Senegal');
		m_CodeMAP.put('RS' , 'Serbia');
		m_CodeMAP.put('SC' , 'Seychelles');
		m_CodeMAP.put('SL' , 'Sierra Leone');
		m_CodeMAP.put('SG' , 'Singapore');
		m_CodeMAP.put('SK' , 'Slovakia');
		m_CodeMAP.put('SI' , 'Slovenia');
		m_CodeMAP.put('SB' , 'Solomon Islands');
		m_CodeMAP.put('SO' , 'Somalia');
		m_CodeMAP.put('ZA' , 'South Africa');
		m_CodeMAP.put('GS' , 'South Georgia And Sandwich Isl.');
		m_CodeMAP.put('ES' , 'Spain');
		m_CodeMAP.put('LK' , 'Sri Lanka');
		m_CodeMAP.put('SD' , 'Sudan');
		m_CodeMAP.put('SR' , 'Suriname');
		m_CodeMAP.put('SJ' , 'Svalbard And Jan Mayen');
		m_CodeMAP.put('SZ' , 'Swaziland');
		m_CodeMAP.put('SE' , 'Sweden');
		m_CodeMAP.put('CH' , 'Switzerland');
		m_CodeMAP.put('SY' , 'Syrian Arab Republic');
		m_CodeMAP.put('TW' , 'Taiwan');
		m_CodeMAP.put('TJ' , 'Tajikistan');
		m_CodeMAP.put('TZ' , 'Tanzania');
		m_CodeMAP.put('TH' , 'Thailand');
		m_CodeMAP.put('TL' , 'Timor-Leste');
		m_CodeMAP.put('TG' , 'Togo');
		m_CodeMAP.put('TK' , 'Tokelau');
		m_CodeMAP.put('TO' , 'Tonga');
		m_CodeMAP.put('TT' , 'Trinidad And Tobago');
		m_CodeMAP.put('TN' , 'Tunisia');
		m_CodeMAP.put('TR' , 'Turkey');
		m_CodeMAP.put('TM' , 'Turkmenistan');
		m_CodeMAP.put('TC' , 'Turks And Caicos Islands');
		m_CodeMAP.put('TV' , 'Tuvalu');
		m_CodeMAP.put('UG' , 'Uganda');
		m_CodeMAP.put('UA' , 'Ukraine');
		m_CodeMAP.put('AE' , 'United Arab Emirates');
		m_CodeMAP.put('GB' , 'United Kingdom');
		m_CodeMAP.put('US' , 'United States');
		m_CodeMAP.put('UM' , 'United States Outlying Islands');
		m_CodeMAP.put('UY' , 'Uruguay');
		m_CodeMAP.put('UZ' , 'Uzbekistan');
		m_CodeMAP.put('VU' , 'Vanuatu');
		m_CodeMAP.put('VE' , 'Venezuela');
		m_CodeMAP.put('VN' , 'Viet Nam');
		m_CodeMAP.put('VG' , 'Virgin Islands British');
		m_CodeMAP.put('VI' , 'Virgin Islands U.S.');
		m_CodeMAP.put('WF' , 'Wallis And Futuna');
		m_CodeMAP.put('EH' , 'Western Sahara');
		m_CodeMAP.put('YE' , 'Yemen');
		m_CodeMAP.put('ZM' , 'Zambia');
		m_CodeMAP.put('ZW' , 'Zimbabwe');
		
    	

    }
    
    global String ConvertCode(String sCountry)
    {
    	String sCountryBack = sCountry;
    	sCountry = sCountry.toUpperCase();
   		String sFullCountry = m_CodeMAP.get(sCountry);
   		if(sFullCountry == null)
   		{
   			String subject = 'FB lead - country code not recognized (' + sCountry + ')';
			String sContent = 'Country code was not recognized ' + sCountry;
			Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			mail.setHtmlBody(sContent);
		    mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
		    mail.setSubject(subject);
		    Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
		    return sCountryBack;
   		}
    	return sFullCountry;
    }
    
    
    
}