
import at.dire.copter.read {
	Operand,
	AbstractOptionReader,
	OptionOrOperand,
	Option,
	gnuOptions
}

"[[at.dire.copter.read::OptionReader]] that implements the rules defined by *Gnu getopt*."
see(`value gnuOptions`)
shared class GnuOptionReader({String*} arguments) extends AbstractOptionReader(arguments) {

	"This is set to true when a `--` is read from the command line. This causes all subsequent command line entries to be read as operands."
	variable Boolean ignoreOptions = false;

	shared actual OptionOrOperand|Finished readNextOption(Iterator<String> arguments) {
		// Read the next argument
		value argument = arguments.next();

		if (is Finished argument) {
			// No more arguments to read. Return.
			return finished;
		}

		// Check the first char. If it exists (not an empty operand) and is `-` we are dealing with a (possibly long) option, an operand otherwise.
		if (!ignoreOptions, exists value firstChar = argument.first, firstChar == '-') {
			// Reading an option. Check if the second char is also a "-", which makes it a long option.
			value secondChar = argument[1];

			if (!exists secondChar) {
				// The argument only contains a single "-" and nothing else. Treated as operand.
				return Operand(argument);
			} else if (secondChar == '-') {
				// Second char is a "-" as well. Treat as long option.
				// Another special case: If the value is just "--", ignore it and switch to operand-mode; unless we are already in operand mode...
				if (argument.size == 2) {
					ignoreOptions = true;

					// Skip to the next option.
					return readNextOption(arguments);
				}

				return Option(argument, argument[2...]);
			} else {
				// Read a short option.
				return GnuShortOption(argument[1...]);
			}
		} else {
			// Read value as operand.
			return Operand(argument);
		}
	}
}
