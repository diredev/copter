import at.dire.copter.read {
	OptionReader,
	OptionOrOperand,
	gnuOptions
}

import ceylon.test {
	assertEquals,
	test
}

"Test reading a few options in various ways. Similar to the unix `ls` command."
test
void testLS() {
	value args1 = ["--all", "-lI", "*.txt"];
	testLSReader(gnuOptions.createReader(args1));

	value args2 = ["--all", "-l", "-I", "*.txt"];
	testLSReader(gnuOptions.createReader(args2));

	value args3 = ["--all", "-lI*.txt"];
	testLSReader(gnuOptions.createReader(args3));
}

void testLSReader(OptionReader reader) {
	value allFlag = reader.read();
	assert (is OptionOrOperand allFlag);
	assertEquals(allFlag.name, "all");

	value listFlag = reader.read();
	assert (is OptionOrOperand listFlag);
	assertEquals(listFlag.name, "l");

	value ignoreOption = reader.read();
	assert (is OptionOrOperand ignoreOption);
	assertEquals(ignoreOption.name, "I");
	assertEquals(reader.readValue(), "*.txt");
}

test
void testRead() {
	value args = ["-ab", "--long-name", "operand", "--name=VALUE WITH SPACE", "moreOperands"];
	value reader = gnuOptions.createReader(args);

	// Read first option
	value firstFlag = reader.read();
	assert (is OptionOrOperand firstFlag);
	assertEquals(firstFlag.name, "a");

	// Second flag
	value secondFlag = reader.read();
	assert (is OptionOrOperand secondFlag);
	assertEquals(secondFlag.name, "b");

	// Long name flag
	value longNamed = reader.read();
	assert (is OptionOrOperand longNamed);
	assertEquals(longNamed.name, "long-name");

	// Operand.
	value operand = reader.read();
	assert (is OptionOrOperand operand);
	assertEquals(operand.name, "");

	value operandValue = reader.readValue();
	assertEquals(operandValue, "operand");

	// Option with value
	value longNameWithValue = reader.read();
	assert (is OptionOrOperand longNameWithValue);
	assertEquals(longNameWithValue.name, "name");

	value optValue = reader.readOptionalValue();
	assertEquals(optValue, "VALUE WITH SPACE");

	// Another operand
	value anotherOperand = reader.read();
	assert (is OptionOrOperand anotherOperand);
	assertEquals(anotherOperand.name, "");

	value anotherOperandValue = reader.readValue();
	assertEquals(anotherOperandValue, "moreOperands");
}

test
void testReadSingleDash() {
	value args = ["--someOption", "someOperand", "-", "-a"];
	value reader = gnuOptions.createReader(args);

	// Read first option
	value firstOption = reader.read();
	assert (is OptionOrOperand firstOption);
	assertEquals(firstOption.name, "someOption");

	value operand = reader.read();
	assert (is OptionOrOperand operand);
	assertEquals(operand.name, "");
	assertEquals(reader.readValue(), "someOperand");

	// "-" should be returned as operand.
	value dashOperand = reader.read();
	assert (is OptionOrOperand dashOperand);
	assertEquals(dashOperand.name, "");
	assertEquals(reader.readValue(), "-");

	value secondOption = reader.read();
	assert (is OptionOrOperand secondOption);
	assertEquals(secondOption.name, "a");
}

test
void testReadDoubleDash() {
	value args = ["--someOption", "--", "operand", "--treat-as-operand"];
	value reader = gnuOptions.createReader(args);

	// Read first option
	value firstOption = reader.read();
	assert (is OptionOrOperand firstOption);
	assertEquals(firstOption.name, "someOption");

	// "--" will be skipped, so read the next operand instead.
	value operand = reader.read();
	assert (is OptionOrOperand operand);
	assertEquals(operand.name, "");
	assertEquals(reader.readValue(), "operand");

	// The next option will also be treated as operand.
	value ignoredOption = reader.read();
	assert (is OptionOrOperand ignoredOption);
	assertEquals(ignoredOption.name, "");
	assertEquals(reader.readValue(), "--treat-as-operand");
}

test
suppressWarnings ("unusedDeclaration")
void testReadLoop() {
	value args = ["--someOption", "--", "operand", "--treat-as-operand"];
	value optional = false;

	// Create a reader around your arguments.
	OptionReader reader = gnuOptions.createReader(args);

	// Continue reading until you reach [[Finished]]
	while (!is Finished option = reader.read()) {
		// Check if this is an operand.
		if (option.operand) {
			// Treat as operand.
		} else {
			// Treat as option. Use [[ReadResult.name]] to get the option's name
			// this does not contain the "--" or "-" prefix.
			value name = option.name;
		}

		// For some options (and all operands), you'll read a value (which may also be optional)
		// This could return null when optional and no value was given.
		value optionValue = reader.readValue();
		//value optionValueOptional = reader.readOptionalValue();

		// Make sure to check for ParseException.
		if (is ParseException optionValue) {
			// Handle invalid command line arguments here.
		}

		// Handle option and value here.
	}
}
