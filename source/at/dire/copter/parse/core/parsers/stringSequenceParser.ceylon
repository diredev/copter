import at.dire.copter.parse.core {
	ValueParser
}

"This parser will parse a sequence of String values. When it encounters a Null value
 (i.e. an optional value) it will return a [[ParseException]] instead."
object stringSequenceParser satisfies ValueParser<String[]> {
	shared actual String[]|ParseException parse(String?[] values) {
		value nonNullValues = values.coalesced.sequence();

		if(nonNullValues.size != values.size) {
			//TODO: use an assertion here? This is a programming issue, I guess...
			return ParseException("Optional values are not allowed here.");
		}

		return nonNullValues;
	}

	parseSingle(String? stringValue) => if(exists stringValue) then [stringValue] else [];
	priority => -1000;
}