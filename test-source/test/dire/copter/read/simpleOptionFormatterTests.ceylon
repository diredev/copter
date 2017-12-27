import at.dire.copter.read {
	SimpleOptions,
	OptionReaderFactory
}
import at.dire.copter.read.collect {
	AvailableOption
}

import ceylon.test {
	test,
	assertEquals
}

OptionReaderFactory simpleOptions = SimpleOptions();

"Test for [[at.dire.copter.read::SimpleOptions.formatOption]]."
test
void testSimpleFormatOption() {
	// Short option without value (-v)
	value verboseShort = simpleOptions.formatOption("v", false);
	assertEquals(verboseShort, "-v");

	// Long option without value (--verbose)
	value verbose = simpleOptions.formatOption("verbose", false);
	assertEquals(verbose, "-verbose");

	// Short option with required value (-f VALUE)
	value fileShort = simpleOptions.formatOption("f", true);
	assertEquals(fileShort, "-f=VALUE");

	// Long option with required value (--file=VALUE)
	value file = simpleOptions.formatOption("file", true);
	assertEquals(file, "-file=VALUE");

	// Short option with optional value (-n[VALUE])
	value nameShort = simpleOptions.formatOption("n", true, false);
	assertEquals(nameShort, "-n[=VALUE]");

	// Long option with optional value (--name[=VALUE])
	value name = simpleOptions.formatOption("name", true, false);
	assertEquals(name, "-name[=VALUE]");

	// Long option with custom VALUE name (--test=TEST).
	value modValue = simpleOptions.formatOption("test", true, true, "TEST");
	assertEquals(modValue, "-test=TEST");
}

"Test for [[at.dire.copter.read::SimpleOptions.formatOperand]]."
test
void testSimpleFormatOperand() {
	// Format required operand, single value
	value singleFile = simpleOptions.formatOperand("FILE", false, true);
	assertEquals(singleFile, "<FILE>");

	// Format required operand, multi value
	value multiFile = simpleOptions.formatOperand("FILE", true, true);
	assertEquals(multiFile, "<FILE>...");

	value singleOptional = simpleOptions.formatOperand("FILE", false, false);
	assertEquals(singleOptional, "[<FILE>]");

	value multiOptional = simpleOptions.formatOperand("FILE", true, false);
	assertEquals(multiOptional, "[<FILE>]...");
}

"Test for both [[at.dire.copter.read::SimpleOptions.formatOptionName]] and [[at.dire.copter.read::SimpleOptions.formatOptionNames]]."
test
void testSimpleFormatOptionName() {
	// Name, required, value required
	value nameOption = AvailableOption("name", ["n", "name"], true, true, true);
	value name = simpleOptions.formatOptionName(nameOption);
	value nameOut = simpleOptions.formatOptionNames(nameOption);
	assertEquals(name, "-n=VALUE");
	assertEquals(nameOut, "-n, -name=VALUE"); //TODO: Why this direction???

	// Verbose, required, no value
	value verboseOption = AvailableOption("verbose", ["v", "verbose"], false, false);
	value verbose = simpleOptions.formatOptionName(verboseOption);
	value verboseOut = simpleOptions.formatOptionNames(verboseOption);
	assertEquals(verbose, "-v");
	assertEquals(verboseOut, "-v, -verbose");

	// Option, not required, value not required.
	value optionalValueOption = AvailableOption("optional", ["x"], false, true, false, "X");
	value optionalValue = simpleOptions.formatOptionName(optionalValueOption);
	value optionalValueOut = simpleOptions.formatOptionNames(optionalValueOption);
	assertEquals(optionalValue, "-x[=VALUE]");
	assertEquals(optionalValueOut, "-x[=VALUE]");

	// Option with custom value label, long name
	value optionalValue2 = simpleOptions.formatOptionName(optionalValueOption, "TEST");
	value optionalValue2Out = simpleOptions.formatOptionNames(optionalValueOption, "TEST");
	assertEquals(optionalValue2, "-x[=TEST]");
	assertEquals(optionalValue2Out, "-x[=TEST]");
}
