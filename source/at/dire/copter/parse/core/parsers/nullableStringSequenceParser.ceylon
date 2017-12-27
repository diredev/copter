import at.dire.copter.parse.core {
	ValueParser
}

"This very simple parser will just return all values as a sequence of Strings or Nulls, i.e. exactly what we get as input."
object nullableStringSequenceParser satisfies ValueParser<String?[]> {
	parse(String?[] values) => values.sequence();
	parseSingle(String? stringValue) => [stringValue];
	priority => -1000;
}