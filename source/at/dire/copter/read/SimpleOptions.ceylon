import at.dire.copter.read.impl {
	SimpleOptionReader
}

"A Java-style option reader and formatter using a configurable prefix and value separator.

 Does not differentiate between short and long options at all."
see (`value gnuOptions`)
shared class SimpleOptions(
	"Single character prefix to mark options."
	Character prefix = '-',
	"Separator between an option's name and value."
	Character valueSeparator = '=') satisfies OptionReaderFactory {

	createReader({String*} arguments) => SimpleOptionReader(arguments, prefix, valueSeparator);

	shared actual String formatOption(String name, Boolean readValue, Boolean valueRequired, String valueLabel) {
		value result = StringBuilder();

		// Write prefix and name.
		result.appendCharacter(prefix);
		result.append(name);

		// Write value?
		if(readValue) {
			if(!valueRequired) {
				result.append("[");
			}

			result.appendCharacter(valueSeparator);
			result.append(valueLabel);

			if(!valueRequired)  {
				result.append("]");
			}
		}

		return result.string;
	}
}
