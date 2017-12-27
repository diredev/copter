"Parser for tring values.

 Note that this class may translate null to an empty String!"
shared object stringParser
		extends SingleValueParser<String>() {
	default => "";
	parseImpl(String stringValue) => stringValue;
	priority => -1000;
}
