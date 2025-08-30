public class TextToCollection {
    @InvocableMethod
    public static List<List<String>> splitText(List<String> inputs) {
        List<List<String>> results = new List<List<String>>();
        for (String input : inputs) {
            if (String.isNotBlank(input)) {
                // Split the text using ":" as the delimiter
                results.add(input.split(':'));
            } else {
                results.add(new List<String>());
            }
        }
        return results;
    }
}