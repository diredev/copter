import at.dire.copter.parse.core.parsers {
	SingleValueParser,
	ValueParserProvider
}

"Used to translate a list of option values read on the command line to another type."
see (`interface ValueParserFactory`, `class SingleValueParser`, `class ValueParserProvider`)
shared interface ValueParser<out Result=Anything> {
	"Parse the list of values and return the result here. If that is not possible, you may return a [[ParseException]].

	 If you do not support multiple values, parse the [[last|Sequence.last]] entry in the list, if any."
	shared formal Result|ParseException parse(
		"List of values. May contain null when reading optional values."
		String?[] values);

	"The same as [[ValueParser.parse]] but parse a single value instead."
	shared formal Result|ParseException parseSingle(String? stringValue);

	"Return a priority for this parser. This is used to try parsers in the correct order when dealing with union types. The lower the priority, the earlier a parser is used.

	 This is important because many parsers are able to cope with the same value (e.g. \"1\" may be parsed by [[at.dire.copter.parse.core.parsers::floatParser]],
	 [[at.dire.copter.parse.core.parsers::integerParser]] and [[at.dire.copter.parse.core.parsers::stringParser]]). For your own parsers, you can leave this at the
	 default value (0) because all common parser have a higher priority."
	shared default Integer priority => 0;

	"Return true here (default) if this parser is usually used to handle multiple values (to create lists, sums, etc.).

	 Note that this has little effect on the parser itself ([[ValueParser.parse]] may still be called with multiple values), but changes the behavior of reading options
	 and operands (empty lists allowed, limitations on multi-value operands, etc.)."
	shared default Boolean multiValue => true;

	"Return true here if you will require at least one value for this, even if the attribute was defaulted. You shouldn't have to worry about this normally."
	shared default Boolean forceRequired => false;
}
