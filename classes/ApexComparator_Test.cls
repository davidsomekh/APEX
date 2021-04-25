@isTest
public with sharing class ApexComparator_Test {
	
	static testmethod void ApexComparatorTest()
	{
		ApexComparator a = new 	ApexComparator();
		Integer i = a.Compare(new Account(),new Account());
	}

}