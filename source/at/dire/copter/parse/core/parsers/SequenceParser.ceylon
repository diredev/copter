import at.dire.copter.parse.core {
	ValueParser
}

"Extension to [[SequentialParser]] that will require at least one value."
class SequenceParser<out Element = Anything>(SequentialParser<Element> inner) satisfies ValueParser<[Element+]> {
	shared actual [Element+]|ParseException parse(String?[] values) {
		value sequential = inner.parse(values);

		if(is ParseException sequential) {
			return sequential;
		} else if(nonempty sequential) {
			return sequential;
		} else {
			// We got an empty sequence, which is not allowed here.
			//TODO: Message?
			return ParseException("Option requires at least one occurrence.");
		}
	}

	parseSingle(String? stringValue) => inner.parseSingle(stringValue);
}