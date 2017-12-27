import at.dire.copter.parse.core {
	ValueParser
}

"Parser indended to handle union types."
see(`class UnionTypeValueParserFactory`)
class UnionTypeValueParser<out Result = Anything>(
	"The list of parsers to try. Has to be in order of priority"
	[ValueParser<Result>+] parsers ,
	"Parser used to handle the default value."
	ValueParser<Result> defaultParser = parsers.first
) satisfies ValueParser<Result> {

	shared actual Result|ParseException parse(String?[] values) {
		// Try parsing with all parsers in order.
		variable ParseException? parseException = null;

		for(parser in parsers) {
			value result = parser.parse(values);

			if(!is ParseException result) {
				return result;
			} else {
				parseException = result;
			}
		}

		// No parser was able to handle the value. Return the last ParseException or fallback to a generic message.
		return parseException else ParseException("Failed to parse values to any union type.");
	}

	shared actual Result|ParseException parseSingle(String? stringValue) {
		// No value?
		if(!exists stringValue) {
			return defaultParser.parseSingle(stringValue);
		}

		// Try parsing with all parsers
		variable ParseException? parseException = null;

		for(parser in parsers) {
			value result = parser.parseSingle(stringValue);

			if(!is ParseException result) {
				return result;
			} else {
				parseException = result;
			}
		}

		// No matching parser. Return the last ParseException if possible.
		return parseException else ParseException("Failed to parse values to any union type.");
	}

	priority = -10;
	multiValue = false;
}