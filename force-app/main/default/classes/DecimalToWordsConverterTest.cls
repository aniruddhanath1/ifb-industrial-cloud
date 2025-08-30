@isTest
public class DecimalToWordsConverterTest {
    
    @isTest
    static void testConvertDecimalToWords_WholeNumber() {
        Decimal digit = 12345;
        String result = DecimalToWordsConverter.convertDecimalToWords(digit);
    }
    
    @isTest
    static void testConvertDecimalToWords_DecimalNumber() {
        Decimal digit = 12345.67;
        String result = DecimalToWordsConverter.convertDecimalToWords(digit);
        
    }
    
    @isTest
    static void testConvertDecimalToWords_Zero() {
        Decimal digit = 0;
        String result = DecimalToWordsConverter.convertDecimalToWords(digit);
    }
    
    
    @isTest
    static void testConvertDecimalToWords_NoDecimalPart() {
        Decimal digit = 12345.00;
        String result = DecimalToWordsConverter.convertDecimalToWords(digit);
    }
    
    @isTest
    static void testConvertDecimalToWords_NoDecimalPart1() {
        Decimal digit = 12345.00;
        String result = DecimalToWordsConverter.convertDecimalToWords(digit);
    }
    
    @isTest
    static void testConvertDecimalToWords_NoDecimalPart2() {
        Decimal digit = 12345.00;
        String result = DecimalToWordsConverter.convertDecimalToWords(digit);
    }

}