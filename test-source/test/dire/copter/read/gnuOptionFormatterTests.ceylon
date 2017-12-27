import at.dire.copter.read {
	gnuOptions
}
import at.dire.copter.read.collect {
	AvailableOption
}

import ceylon.test {
	test,
	assertEquals
}

"Test for [[at.dire.copter.read::gnuOptions.formatOption]]."
test
void testFormatOption() {
	// Short option without value (-v)
	value verboseShort = gnuOptions.formatOption("v", false);
	assertEquals(verboseShort, "-v");

	// Long option without value (--verbose)
	value verbose = gnuOptions.formatOption("verbose", false);
	assertEquals(verbose, "--verbose");

	// Short option with required value (-f VALUE)
	value fileShort = gnuOptions.formatOption("f", true);
	assertEquals(fileShort, "-f VALUE");

	// Long option with required value (--file=VALUE)
	value file = gnuOptions.formatOption("file", true);
	assertEquals(file, "--file=VALUE");

	// Short option with optional value (-n[VALUE])
	value nameShort = gnuOptions.formatOption("n", true, false);
	assertEquals(nameShort, "-n[VALUE]");

	// Long option with optional value (--name[=VALUE])
	value name = gnuOptions.formatOption("name", true, false);
	assertEquals(name, "--name[=VALUE]");

	// Long option with custom VALUE name (--test=TEST).
	value modValue = gnuOptions.formatOption("test", true, true, "TEST");
	assertEquals(modValue, "--test=TEST");
}

"Test for [[at.dire.copter.read::gnuOptions.formatOperand]]."
test
void testFormatOperand() {
	// Format required operand, single value
	value singleFile = gnuOptions.formatOperand("FILE", false, true);
	assertEquals(singleFile, "<FILE>");

	// Format required operand, multi value
	value multiFile = gnuOptions.formatOperand("FILE", true, true);
	assertEquals(multiFile, "<FILE>...");

	value singleOptional = gnuOptions.formatOperand("FILE", false, false);
	assertEquals(singleOptional, "[<FILE>]");

	value multiOptional = gnuOptions.formatOperand("FILE", true, false);
	assertEquals(multiOptional, "[<FILE>]...");
}

"Test for both [[at.dire.copter.read::gnuOptions.formatOptionName]] and [[at.dire.copter.read::gnuOptions.formatOptionNames]]."
test
void testFormatOptionName() {
	// Name, required, value required
	value nameOption = AvailableOption("name", ["n", "name"], true, true, true);
	value name = gnuOptions.formatOptionName(nameOption);
	value nameOut = gnuOptions.formatOptionNames(nameOption);
	assertEquals(name, "-n VALUE");
	assertEquals(nameOut, "-n, --name=VALUE"); //TODO: Why this direction???

	// Verbose, required, no value
	value verboseOption = AvailableOption("verbose", ["v", "verbose"], false, false);
	value verbose = gnuOptions.formatOptionName(verboseOption);
	value verboseOut = gnuOptions.formatOptionNames(verboseOption);
	assertEquals(verbose, "-v");
	assertEquals(verboseOut, "-v, --verbose");

	// Option, not required, value not required.
	value optionalValueOption = AvailableOption("optional", ["x"], false, true, false, "X");
	value optionalValue = gnuOptions.formatOptionName(optionalValueOption);
	value optionalValueOut = gnuOptions.formatOptionNames(optionalValueOption);
	assertEquals(optionalValue, "-x[VALUE]");
	assertEquals(optionalValueOut, "-x[VALUE]");

	// Option with custom value label, long name
	value optionalValue2 = gnuOptions.formatOptionName(optionalValueOption, "TEST");
	value optionalValue2Out = gnuOptions.formatOptionNames(optionalValueOption, "TEST");
	assertEquals(optionalValue2, "-x[TEST]");
	assertEquals(optionalValue2Out, "-x[TEST]");
}
