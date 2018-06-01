import at.dire.copter.parse.core {
	ValueParser
}

"This singleton object will always parse values to null and will fail parsing if the input isn't null as well."
see(`class UnionTypeValueParser`)
object nullParser satisfies ValueParser<Null> {
	shared actual ParseException? parse(String?[] values) {
		// Only allow actual null values.
		if(values.any((element) => element exists)) {
			return ParseException("Cannot use null parser to handle lists containing anything but null.");
		}

		return null;
	}

	shared actual ParseException? parseSingle(String? stringValue) {
		if(exists stringValue) {
			return ParseException("Failed to parse '``stringValue``'.");
		}

		return null;
	}

	priority = -2000;
}