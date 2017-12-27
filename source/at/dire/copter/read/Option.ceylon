"An option containing a name, which is optionally followed by a value (separated by [[Option.valueSeparator]]).

 Can be used for Java or Microsoft style readers in addition to *Gnu getopt*."
see(`class Operand`)
shared class Option(
	shared actual String readName,
	"Name with optional value (separated by `=`)."
	String argValue,
	"Separator between name and value."
	Character valueSeparator = '=') satisfies OptionOrOperand {

	// Split by "=" and fill name and predefined value (if present, null otherwise)
	value nameAndValue = argValue.split { splitting = valueSeparator.equals; limit = 2; };
	name = nameAndValue.first;
	value predefinedValue = nameAndValue.getFromFirst(1);

	"Set to true when [[Option.readValue]] has been executed once."
	variable Boolean valueWasRead = false;

	shared actual String|ParseException readValue(Iterator<String> moreArguments) {
		value result = readOptionalValue(moreArguments);

		if (exists result) {
			return result;
		}

		// No value was given together with the option. Read next value from iterator if possible.
		value nextValue = moreArguments.next();

		if (is Finished nextValue) {
			return ParseException("No value for option '``name``' given.");
		}

		return nextValue;
	}

	shared actual String?|ParseException readOptionalValue(Iterator<String> moreArguments) {
		"Value has already been read."
		assert (!valueWasRead);
		valueWasRead = true;

		// If a predefined value was given, return it now.
		if (exists lCurrentValue = predefinedValue) {
			return lCurrentValue;
		}

		// No value was specified with the argument ("="), return null in thi case for optional values.
		return null;
	}

	string => name + valueSeparator.string + (predefinedValue else "<null>");
	operand => false;
}
