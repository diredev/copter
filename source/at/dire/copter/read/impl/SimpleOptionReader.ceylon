import at.dire.copter.read {
	AbstractOptionReader,
	OptionOrOperand,
	Operand,
	Option,
	SimpleOptions
}

"A Java-style option reader using a prefix and value separator.

 Does not differentiate between short and long options at all."
see(`class SimpleOptions`)
shared class SimpleOptionReader(
	"The command-line arguments."
	{String*} args,
	"Single character prefix to mark options."
	Character prefix = '-',
	"Separator between an option's name and value."
	Character valueSeparator = '=') extends AbstractOptionReader(args) {

	shared actual OptionOrOperand|Finished readNextOption(Iterator<String> arguments) {
		// Read the next argument
		value argument = arguments.next();

		if (is Finished argument) {
			// No more arguments to read. Return.
			return finished;
		}

		// Check if the argument starts with one of my prefixes (and is not empty or just the prefix)
		value firstChar = argument.first;

		if (exists firstChar, argument.longerThan(1), prefix == firstChar) {
			return Option(argument, argument.rest, valueSeparator);
		} else {
			// Does not start with prefix (or is empty or just the prefix). Return as operand.
			return Operand(argument);
		}
	}
}
