"This parser selects a value based on a map of predefined values."
see (`class CaseValueParserFactory`)
shared class CaseValueParser<out T=Anything>(
	"Map with the predefined values given by key."
	Map<String,T> namedValues) extends SingleValueParser<T>() {

	default => ParseException("Not one of the parser values.");

	shared actual T|ParseException parseImpl(String stringValue) {
		value item = namedValues[stringValue];

		if (!exists item) {
			return default;
		}

		return item;
	}

	priority = -300;
}
