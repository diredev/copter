import at.dire.copter.parse.core.parsers {
	CountingParser
}

import ceylon.test {
	test,
	assertEquals
}

"Test for [[at.dire.copter.parse.core.parsers::CountingParser.parseSingle]]."
test void testCountingSingleValue() {
	value parser = CountingParser();

	// Test values aren't supported.
	value emptyResult = parser.parseSingle("");
	assert(is ParseException emptyResult);

	value textResult = parser.parseSingle("x");
	assert(is ParseException textResult);

	// Null will be treated as false here (which will return -1)
	assertEquals(parser.parseSingle(null), -1);

	// Parsing a single (boolean) value will return 0 or 1
	assertEquals(parser.parseSingle("true"), 1);
	assertEquals(parser.parseSingle("false"), -1);
}

"Test for [[at.dire.copter.parse.core.parsers::CountingParser.parse]]."
test void testCountingParser() {
	value parser = CountingParser();

	// Parsing String is not allowed.
	value textResult = parser.parse(["true", "test"]);
	assert(is ParseException textResult);

	// Parsing empty should return 0.
	assertEquals(parser.parse([]), 0);

	// Parsing null will be handled as false.
	assertEquals(parser.parse(["true", null]), 0);

	// Parsing booleans will sum up.
	assertEquals(parser.parse(["true", "true", "false", "true"]), 2);
}