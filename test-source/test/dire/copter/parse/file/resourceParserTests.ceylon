import at.dire.copter.parse.file {
	ResourceParser
}

import ceylon.test {
	test
}

test
void testResourceParser() {
	value parser = ResourceParser();

	// Null is not allowed.
	value nullResult = parser.parseSingle(null);
	assert(is ParseException nullResult);

	//TODO: Add more tests here...
}
