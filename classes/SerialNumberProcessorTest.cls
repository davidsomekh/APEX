@isTest
private class SerialNumberProcessorTest {

    @isTest
    static void testProcessSerialNumbers() {
        // Create test data
        SerialNumberProcessor.SerialNumberInput input1 = new SerialNumberProcessor.SerialNumberInput();
        input1.serialNumbers = 'SN1\nSN2\nSN3';

        SerialNumberProcessor.SerialNumberInput input2 = new SerialNumberProcessor.SerialNumberInput();
        input2.serialNumbers = 'SN4\nSN5\nSN6';

        List<SerialNumberProcessor.SerialNumberInput> inputs = new List<SerialNumberProcessor.SerialNumberInput>();
        inputs.add(input1);
        inputs.add(input2);

        // Call the method to be tested
        List<SerialNumberProcessor.SerialNumberOutput> results = SerialNumberProcessor.processSerialNumbers(inputs);

        // Assert the results
        System.assertEquals(2, results.size(), 'Expected 2 results');

        // Check the first result
        SerialNumberProcessor.SerialNumberOutput result1 = results[0];
        System.assertEquals(3, result1.processedSerialNumbers.size(), 'Expected 3 processed serial numbers in the first result');
        System.assertEquals('SN1', result1.processedSerialNumbers[0], 'Unexpected processed serial number');
        System.assertEquals('SN2', result1.processedSerialNumbers[1], 'Unexpected processed serial number');
        System.assertEquals('SN3', result1.processedSerialNumbers[2], 'Unexpected processed serial number');

        // Check the second result
        SerialNumberProcessor.SerialNumberOutput result2 = results[1];
        System.assertEquals(3, result2.processedSerialNumbers.size(), 'Expected 3 processed serial numbers in the second result');
        System.assertEquals('SN4', result2.processedSerialNumbers[0], 'Unexpected processed serial number');
        System.assertEquals('SN5', result2.processedSerialNumbers[1], 'Unexpected processed serial number');
        System.assertEquals('SN6', result2.processedSerialNumbers[2], 'Unexpected processed serial number');
    }
}