import at.dire.copter.parse.core {
	ValueParser
}

"This parser will call a given [[ParsingValueParser.parseMethod]] for every value.

 Use together with parse methods like [[Integer.parse]], [[Float.parse]], etc."
class ParsingValueParser<Result>(Callable<Result|ParseException, [String]> parseMethod, shared actual Result default, shared actual Integer priority = 0) extends SingleValueParser<Result>() {
	parseImpl(String stringValue) => parseMethod(stringValue);
}

//TODO: Handle "yes" and "no" here as well?
"A basic parser to handle [[Boolean]] values."
see (`function Boolean.parse`)
shared ValueParser<Boolean> booleanParser = ParsingValueParser(Boolean.parse, false, -100);

"A basic parser to handle [[Float]] values."
see (`function Float.parse`)
shared ValueParser<Float> floatParser = ParsingValueParser(Float.parse, 0.0, -110);

"A basic parser to handle [[Integer]] values."
see (`function Integer.parse`)
shared ValueParser<Integer> integerParser = ParsingValueParser(Integer.parse, 0, -100);
