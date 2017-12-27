import at.dire.copter.read {
	OptionOrOperand,
	Option
}

"Short option or a group of short options as defined by *Gnu getopt*.

 If [[GnuShortOption.names]] contains more than a single character, then every call to [[GnuShortOption.readNextName]]
 will move to the next option. Note that calling [[GnuShortOption.readValue]] will read the remainding characters as
 value, as defined by Gnu."
see (`class Option`)
shared class GnuShortOption(
	"One or more short-options as a group."
	String names) satisfies OptionOrOperand {

	"The current position when reading a group of values."
	variable Integer position = 0;

	"Set to true when [[GnuShortOption.readValue]] has been executed."
	variable Boolean valueWasRead = false;

	readNextName() => !valueWasRead && names.defines(++position);
	string => name.string;

	shared actual String name {
		// Return the current character
		value nameChar = names[position];

		"Name was called before or after the end of the list."
		assert (exists nameChar);

		return nameChar.string;
	}

	shared actual String|ParseException readValue(Iterator<String> moreArguments) {
		value result = readOptionalValue(moreArguments);

		if (exists result) {
			return result;
		}

		// No value was given together with the option. Read next value from iterator if possible.
		value nextValue = moreArguments.next();

		if (is Finished nextValue) {
			// No more values to read. Return either parse error or null if optional.
			return ParseException("No value given for non-optional option '``name``'.");
		}

		return nextValue;
	}

	shared actual String?|ParseException readOptionalValue(Iterator<String> moreArguments) {
		"Value has already been read."
		assert (!valueWasRead);
		valueWasRead = true;

		// If we aren't at the end of the String yet, use the reamining characters.
		value optionValue = this.names[position+1 ...];

		// Was a value read? If empty, we are at the end of the list of characters already.
		if (!optionValue.empty) {
			return optionValue;
		}

		// No value given. For optional values we return null now.
		return null;
	}

	readName => "-" + name;
	operand => false;
}
