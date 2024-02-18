public class SerialNumberProcessor {

    public class SerialNumberOutput {
        @InvocableVariable(label='Processed Serial Numbers' required=true)
        public List<String> processedSerialNumbers;
    }

    public class SerialNumberInput {
        @InvocableVariable(label='Serial Numbers' required=true)
        public String serialNumbers;
    }

    @InvocableMethod(label='Process Serial Numbers' description='Process a list of serial numbers')
    public static List<SerialNumberOutput> processSerialNumbers(List<SerialNumberInput> inputs) {
        List<SerialNumberOutput> result = new List<SerialNumberOutput>();

        for (SerialNumberInput input : inputs) {
            // Split the input serial numbers by new line
            String[] serialNumberList = input.serialNumbers.split('\n');

            // Create a wrapper class instance to hold processed serial numbers
            SerialNumberOutput output = new SerialNumberOutput();
            output.processedSerialNumbers = new List<String>();

            // Process each serial number
            for (String serialNumber : serialNumberList) {
                // Add the processed serial number to the list
                output.processedSerialNumbers.add(serialNumber.trim()); // Trim to remove any leading/trailing whitespaces
            }

            // Add the wrapper class instance to the result list
            result.add(output);
        }

        return result;
    }
}