import at.dire.copter.parse.core {
	ValueParser
}

"Specialized parser will count the number of true values minus the number of false values.

 Use this with [[at.dire.copter.parse.core.annotations::flag]] and (optionally) with [[at.dire.copter.parse.core.annotations::nonFlag]]
 to implement things like verbosity, etc."
shared class CountingParser() satisfies ValueParser<Integer> {
	shared actual Integer|ParseException parse(String?[] values) {
		variable Integer counter = 0;

		for(stringValue in values) {
			value result = parseSingle(stringValue);

			if(is ParseException result) {
				return result;
			}

			counter += result;
		}

		return counter;
	}

	shared actual Integer|ParseException parseSingle(String? stringValue) {
		value result = booleanParser.parseSingle(stringValue);

		if(is ParseException result) {
			return result;
		}

		// May return -1 here to be consistent with (and usable by) parse().
		return result then 1 else -1;
	}
}
