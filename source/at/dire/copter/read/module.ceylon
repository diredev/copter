import at.dire.copter.read.collect {
	OptionCollector
}

"Allows reading command line options and operands in a clean, simple way.

 This includes validation of allowed options and operands and which require a value or not. This also provides full support for options in the format used
 by *Gnu getopt* (see [[gnuOptions]]) in addition to a simpler, [[Java-style format|SimpleOptions]].

 # Reading Options
 Use an [[OptionReader]] to read command-line options in a simple, forward-only way. The exact option format and rules are implementation specific (e.g. handle short and
 long options with or without values, etc.).

 Use the following basic read-loop as a template:

 ~~~
 // Create a reader around your arguments.
 OptionReader reader = gnuOptions.createReader(args);

 // Continue reading until you reach `Finished`.
 while (!is Finished option = reader.read()) {
 	// Check if this is an operand.
 	if (option.operand) {
 		// Treat as operand.
 	} else {
 		// Treat as option. Use `ReadResult.name` to get the option's name
 		// this does not contain the \"--\" or \"-\" prefix.
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
 ~~~

 Call [[OptionReader.read]] repeatedly until it returns [[Finished]]. This iterates all options and operands in order they are given on the command line.
 If you get an option, you'll have to decide if you also need to read a value for it, in which case you call [[OptionReader.readValue]]. You do the same for operands to get their value.

 # Handling Options
 Most applications will need to collect and interpret the values on the command-line in some way. We should also limit the user to entering known options only. We can do both
 using [[at.dire.copter.read.collect::OptionCollector]].

 Here's a basic example:

 ~~~
 // We first need to define all possible options.
 value collector = OptionCollector {
 	options = [
 		// Basic flags for \"-v\" and \"--verbose\". Note that both use the same key (first argument).
 		AvailableOption(\"a\", [\"a\", \"all\"]),
 		// An option that will read a (required) value.
 		AvailableOption(\"block-size\", [\"block-size\"], true),
 		// Option with optional value and a default value (if no value is given).
 		AvailableOption(\"color\", [\"color\"], false, true, false, \"always\")
 	];
 	operands = [
 		// We can define multiple operands, only one of which may allow multiple values.
 		AvailableOperand(\"singleOperand\"),
 		AvailableOperand(\"multiOperand\", false, true)
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
 value wasDefined = result.isPresent(\"a\");
 value singleValue = result.getValue(\"a\");
 value multiValue = result.getValues(\"a\");
 ~~~

 Note that we define arbitrary [[keys|at.dire.copter.read.collect::AvailableOption.key]] when defining [[options|at.dire.copter.read.collect::AvailableOption]] and [[operands|at.dire.copter.read.collect::AvailableOperand]] and to access the [[at.dire.copter.read.collect::Result]]. We use this to have
 multiple options be handled as the same option (like git's `--sign`, `--signed` and `--no-signed` or similar) and to identify operands. The example above uses
 String keys but we could have used any object here.

 Also note that only a single [[operand|at.dire.copter.read.collect::AvailableOperand]] may have [[multiple values|at.dire.copter.read.collect::AvailableOperand.allowMultiple]]. The multi-value operand may be
 [[required|at.dire.copter.read.collect::AvailableOperand.required]] (i.e. has to be specified at least once) or optional. Operands following the multi-value one must not be optional.

 # Formatting Options
 Use an [[OptionFormatter]] matching your reader (or an [[OptionReaderFactory]]) to format options for documentation purposes.

 # Advanced Functionality
 You can use other modules that are based on this one to do even more things with command line options:
 * `at.dire.copter.parse`: Use annotations to declare options and parse command line arguments into objects.
 * `at.dire.copter.command`: Build simple or *Git*-style applications and handle common options."
see (`interface OptionReader`, `interface OptionReaderFactory`, `value gnuOptions`, `class OptionCollector`, `class SimpleOptions`)
module at.dire.copter.read "1.0.0" {
	import ceylon.logging "1.3.3";
	import ceylon.collection "1.3.3";
}
