import at.dire.copter.read {
	gnuOptions
}
import at.dire.copter.read.collect {
	OptionCollector,
	AvailableOption,
	AvailableOperand,
	Result
}

import ceylon.test {
	test,
	assertTrue,
	assertFalse,
	assertEquals
}

test
suppressWarnings("unusedDeclaration")
void testExample() {
	value args = ["-a", "operand1", "--block-size", "12M", "--color", "operand2", "operand3"];

	// We first need to define all possible options.
	value collector = OptionCollector {
		options = [
			// Basic flags for "-v" and "--verbose". Note that both use the same key (first argument).
			AvailableOption("a", ["a", "all"]),
			// An option that will read a (required) value.
			AvailableOption("block-size", ["block-size"], true),
			// Option with optional value and a default value (if no value is given).
			AvailableOption("color", ["color"], false, true, false, "always")
		];
		operands = [
			// We can define multiple operands, only one of which may allow multiple values.
			AvailableOperand("singleOperand"),
			AvailableOperand("multiOperand", false, true)
		];
	};

	// Create an OptionReader and parse the command line
	value result = collector.collect(gnuOptions.createReader(args));

	// Check if ParseException
	if (is ParseException result) {
		// Do something
		return;
	}

	// We can now access the result by key.
	value wasDefined = result.isPresent("a");
	value singleValue = result.getValue("a");
	value multiValue = result.getValues("a");
}

test
void testParse() {
	value parser = OptionCollector {
		options = [
		AvailableOption("a", ["a", "all"]),
		AvailableOption("block-size", ["block-size"], false, true),
		AvailableOption("c", ["c"]),
		AvailableOption("b", ["b", "escape"]),
		AvailableOption("color", ["color"], false, true, false),
		AvailableOption("help", ["help"], false, false, false, null, true)
		];
		operands = [
			AvailableOperand("singleOperand"),
		AvailableOperand("multiOperand", false, true)
		];
	};

	value args = ["-a", "operand1", "--block-size", "12M", "--color", "operand2", "operand3"];
	value result = parser.collect(gnuOptions.createReader(args));

	"Collect has failed: ``result```"
	assert (!is ParseException result);

	assertTrue(result.isPresent("a"));
	assertFalse(result.isPresent("c"));

	assertTrue(result.isPresent("block-size"));
	assertEquals(result.getValue("block-size"), "12M");

	assertTrue(result.isPresent("color"));
	assertEquals(result.getValue("color"), null);
	assertFalse(result.getValues("color").empty);
	assertEquals(result.getValues("color").first, null);

	assertEquals(result.getValues("singleOperand"), ["operand1"]);
	assertEquals(result.getValues("multiOperand"), ["operand2", "operand3"]);
}

test
void testMissingRequiredOperand() {
	value collector = OptionCollector([], [AvailableOperand("a"), AvailableOperand("b"), AvailableOperand("c")]);

	value args = ["arnold", "bernard"];
	value result = collector.collect(gnuOptions.createReader(args));

	assert (is ParseException result);
	print(result.message);
}

test
void testOperandsRequired() {
	value collector = OptionCollector([], [AvailableOperand("a"), AvailableOperand("b"), AvailableOperand("c")]);

	value args = ["arnold", "bernard", "chloe"];
	value result = collector.collect(gnuOptions.createReader(args));

	assert (is Result<> result);

	assertEquals(result.getValues("a"), ["arnold"]);
	assertEquals(result.getValues("b"), ["bernard"]);
	assertEquals(result.getValues("c"), ["chloe"]);
}

test
void testTooManyOperandValues() {
	// Three required operands.
	value collector = OptionCollector([], [AvailableOperand("a"), AvailableOperand("b"), AvailableOperand("c")]);

	// But four values
	value args = ["arnold", "bernard", "chloe", "dirk"];
	value result = collector.collect(gnuOptions.createReader(args));

	assert (is ParseException result);
	print(result.message);
}

test
void testOperandsOptional1() {
	// Two required operands, two optional (RROO)
	value collector = OptionCollector([], [AvailableOperand("r1"), AvailableOperand("r2"), AvailableOperand("o1", false), AvailableOperand("o2", false)]);

	value args = ["rupert", "ralph"];
	value result = collector.collect(gnuOptions.createReader(args));

	assert (is Result<> result);
	assertEquals(result.getValues("r1"), ["rupert"]);
	assertEquals(result.getValues("r2"), ["ralph"]);
	assertEquals(result.getValues("o1"), []);
	assertEquals(result.getValues("o2"), []);

	// With three values
	value args2 = ["rupert", "ralph", "oliver"];
	value result2 = collector.collect(gnuOptions.createReader(args2));

	assert (is Result<> result2);
	assertEquals(result2.getValues("r1"), ["rupert"]);
	assertEquals(result2.getValues("r2"), ["ralph"]);
	assertEquals(result2.getValues("o1"), ["oliver"]);
	assertEquals(result2.getValues("o2"), []);
}

test
void testOperandsOptional2() {
	// Two required operands, two optional (order is OROR this time.)
	value collector = OptionCollector([], [AvailableOperand("o1", false), AvailableOperand("r1"), AvailableOperand("o2", false), AvailableOperand("r2")]);

	value args = ["rupert", "ralph"];
	value result = collector.collect(gnuOptions.createReader(args));

	assert (is Result<> result);
	assertEquals(result.getValues("o1"), []);
	assertEquals(result.getValues("r1"), ["rupert"]);
	assertEquals(result.getValues("o2"), []);
	assertEquals(result.getValues("r2"), ["ralph"]);

	// With three values
	value args3 = ["rupert", "ralph", "oliver"];
	value result3 = collector.collect(gnuOptions.createReader(args3));

	assert (is Result<> result3);
	assertEquals(result3.getValues("o1"), ["rupert"]);
	assertEquals(result3.getValues("r1"), ["ralph"]);
	assertEquals(result3.getValues("o2"), []);
	assertEquals(result3.getValues("r2"), ["oliver"]);

	// And four values
	value args4 = ["rupert", "ralph", "oliver", "olimar"];
	value result4 = collector.collect(gnuOptions.createReader(args4));

	assert (is Result<> result4);
	assertEquals(result4.getValues("o1"), ["rupert"]);
	assertEquals(result4.getValues("r1"), ["ralph"]);
	assertEquals(result4.getValues("o2"), ["oliver"]);
	assertEquals(result4.getValues("r2"), ["olimar"]);
}

test
void testMultiValueOperand() {
	// One optional operand, a multi-value operand (with a minimum of 0) and another required one.
	value collector = OptionCollector([], [AvailableOperand("o", false), AvailableOperand("m", false, true), AvailableOperand("r")]);

	value args1 = ["rupert"];
	value result1 = collector.collect(gnuOptions.createReader(args1));

	assert (is Result<> result1);
	assertEquals(result1.getValues("o"), []);
	assertEquals(result1.getValues("m"), []);
	assertEquals(result1.getValues("r"), ["rupert"]);

	// With two values
	value args2 = ["rupert", "ralph"];
	value result2 = collector.collect(gnuOptions.createReader(args2));

	assert (is Result<> result2);
	assertEquals(result2.getValues("o"), ["rupert"]);
	assertEquals(result2.getValues("m"), []);
	assertEquals(result2.getValues("r"), ["ralph"]);

	// Three values.
	value args3 = ["rupert", "ralph", "oliver"];
	value result3 = collector.collect(gnuOptions.createReader(args3));

	assert (is Result<> result3);
	assertEquals(result3.getValues("o"), ["rupert"]);
	assertEquals(result3.getValues("m"), ["ralph"]);
	assertEquals(result3.getValues("r"), ["oliver"]);

	// Four values
	value args4 = ["rupert", "ralph", "oliver", "olimar"];
	value result4 = collector.collect(gnuOptions.createReader(args4));

	assert (is Result<> result4);
	assertEquals(result4.getValues("o"), ["rupert"]);
	assertEquals(result4.getValues("m"), ["ralph", "oliver"]);
	assertEquals(result4.getValues("r"), ["olimar"]);

	// And even more values.
	value argsX = ["rupert", "ralph", "oliver", "olimar", "kevin", "sue", "xavier"];
	value resultX = collector.collect(gnuOptions.createReader(argsX));

	assert (is Result<> resultX);
	assertEquals(resultX.getValues("o"), ["rupert"]);
	assertEquals(resultX.getValues("m"), ["ralph", "oliver", "olimar", "kevin", "sue"]);
	assertEquals(resultX.getValues("r"), ["xavier"]);
}
