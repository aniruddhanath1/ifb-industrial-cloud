@IsTest
public class TextToCollectionTest {
    @IsTest
    public static void testSplitTextSingleInput() {
        // Single test input in the format "20:30"
        List<String> inputList = new List<String>{'40:60'};

        // Expected output
        List<List<String>> expectedOutput = new List<List<String>>{
            new List<String>{'40', '60'}
        };

        // Call the method
        List<List<String>> actualOutput = TextToCollection.splitText(inputList);

        // Assert the results
        System.assertEquals(expectedOutput.size(), actualOutput.size(), 'Output size should match expected size.');
        System.assertEquals(expectedOutput[0], actualOutput[0], 'Output should correctly split the input string.');
    }

    @IsTest
    public static void testSplitTextSingleInputEmpty() {
        // Single test input as an empty string
        List<String> inputList = new List<String>{''};

        // Expected output
        List<List<String>> expectedOutput = new List<List<String>>{
            new List<String>() // Empty list for empty string
        };

        // Call the method
        List<List<String>> actualOutput = TextToCollection.splitText(inputList);

        // Assert the results
        System.assertEquals(expectedOutput.size(), actualOutput.size(), 'Output size should match expected size.');
        System.assertEquals(expectedOutput[0], actualOutput[0], 'Output should be an empty list for an empty input string.');
    }

    @IsTest
    public static void testSplitTextSingleInputNull() {
        // Single test input as null
        List<String> inputList = new List<String>{null};

        // Expected output
        List<List<String>> expectedOutput = new List<List<String>>{
            new List<String>() // Empty list for null input
        };

        // Call the method
        List<List<String>> actualOutput = TextToCollection.splitText(inputList);

        // Assert the results
        System.assertEquals(expectedOutput.size(), actualOutput.size(), 'Output size should match expected size.');
        System.assertEquals(expectedOutput[0], actualOutput[0], 'Output should be an empty list for a null input.');
    }
}