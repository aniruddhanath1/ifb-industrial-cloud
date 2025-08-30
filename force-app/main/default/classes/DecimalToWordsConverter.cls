/*
@Author : Yadam
@CreatedDate : 13th June 2024
@Description : This class use by ILMPDFGenerationComCtrl there is convert the digits amount in the words.
*/

public class DecimalToWordsConverter {
    // Arrays to hold words for numbers
    private static final List<String> belowTwenty = new List<String>{'', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'};
    private static final List<String> tens = new List<String>{'', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'};
    private static final List<String> thousands = new List<String>{'', 'Thousand', 'Million', 'Billion'};

    // Method to convert a decimal number to words
    public static String convertDecimalToWords(Decimal no) {
        try{
            Decimal num = no != null ? no : 0;
            // Convert the Decimal to a String and split it into whole and decimal parts
            String[] parts = String.valueOf(num).split('\\.');
            String wholePart = parts[0];
            String decimalPart = parts.size() > 1 ? parts[1] : '0';
            
            // Convert the whole part to words
            String words = convertNumberToWords(Integer.valueOf(wholePart));
            words += ' RUPEES ';
            // Convert the decimal part to words if it exists
            if (decimalPart != '0' && decimalPart != '00') {
                Boolean loopRun = false;
                for (Integer i = 0; i < decimalPart.length(); i++) {
                    words += ' ' + belowTwenty[Integer.valueOf(decimalPart.substring(i, i + 1))];
                    loopRun = true;
                }
                if(loopRun == true){
                    words += ' PAISE ONLY';
                }else{
                    words += ' ONLY';
                }
            }
            if(!words.contains('ONLY')){
                words += ' ONLY';
            }
            
            return words.trim().toUpperCase();
        }
        catch(Exception e){
            insert Utilities.getExceptionErrorLog('DecimalToWordsConverter' , 'convertDecimalToWords', e);
        }
        return null;
    }

    // Helper method to convert numbers less than 1000
    private static String convertNumberToWords(Integer num) {
        if (num == 0) {
            return 'Zero';
        }

        Integer i = 0;
        String words = '';

        // Convert number to words by processing each thousand unit
        while (num > 0) {
            Integer remainder = num - (num / 1000) * 1000; // Equivalent to num % 1000
            if (remainder != 0) {
                words = helper(remainder) + thousands[i] + ' ' + words;
            }
            num = num / 1000;
            i++;
        }

        return words.trim();
    }

    // Helper method for numbers less than 1000
    private static String helper(Integer num) {
        if (num == 0) {
            return '';
        } else if (num < 20) {
            return belowTwenty[num] + ' ';
        } else if (num < 100) {
            return tens[num / 10] + ' ' + helper(num - (num / 10) * 10); // Equivalent to num % 10
        } else {
            return belowTwenty[num / 100] + ' Hundred ' + helper(num - (num / 100) * 100); // Equivalent to num % 100
        }
    }
}