import at.dire.copter.parse.core {
	ValueParser
}

"Base implementation for [[parsers|at.dire.copter.core.pars:ValuePearser]] to handle single values only.

 The implementation used here will use the very last value provided for an Option. This matches the behavior of Unix tools."
shared abstract class SingleValueParser<out Result>() satisfies ValueParser<Result> {
	parse(String?[] values) => parseSingle(values.last);

	"A sane default value or an error message.

	 This is called when no value is provided for an option."
	shared default Result|ParseException default => ParseException("Option requires a value.");

	shared actual Result|ParseException parseSingle(String? stringValue) {
		if(exists stringValue) {
			return parseImpl(stringValue);
		} else {
			return default;
		}
	}

	"Parses a single value."
	shared formal Result|ParseException parseImpl(String stringValue);

	multiValue => false;
}
