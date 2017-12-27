import at.dire.copter.read {
	Operand,
	OptionOrOperand,
	OptionReader
}

"Base implementation of [[OptionReader]].

 Uses [[OptionOrOperand]] and [[Operand]] internally. Provide an implementation for [[AbstractOptionReader.readNextOption]] to create your own reader.
 You will probably also need to create your own [[OptionOrOperand]]-type(s), reuse the basic [[Operand]] if plausible."
see (`interface OptionOrOperand`, `class Operand`)
shared abstract class AbstractOptionReader(
	"List of command-line arguments."
	{String*} arguments) satisfies OptionReader {

	value argumentIt = arguments.iterator();

	"The current option or operand or null. Used when reading groups of short-options."
	variable OptionOrOperand? currentOptionOrOperand = null;

	shared actual OptionOrOperand|Finished read() {
		// If we still have an active option, try to read the next value first. This is only relevant for short option groups.
		if (exists value lCurrentOptionOrOperand = currentOptionOrOperand) {
			// If we can read the next value of the current option, return true.
			if (lCurrentOptionOrOperand.readNextName()) {
				return lCurrentOptionOrOperand;
			} else {
				// No more elements. Remove the current option.
				this.currentOptionOrOperand = null;
			}
		}

		// Read the next option.
		value nextOption = readNextOption(argumentIt);

		if (is Finished nextOption) {
			return nextOption;
		} else {
			// Remember the current option for next call.
			this.currentOptionOrOperand = nextOption;

			return nextOption;
		}
	}

	"Return the next [[option or operand|OptionOrOperand]].

	 It's up to the implementation to interpret the prefixes for options (*-* and *--* in the case of Gnu options) and any special rules."
	shared formal OptionOrOperand|Finished readNextOption(
		"Iterator of all remaining command-line arguments."
		Iterator<String> arguments);

	shared actual String|ParseException readValue() {
		"No current option set or at the end of the option list. Make sure to call [[AbstractOptionReader.read]] first!"
		assert (exists option = this.currentOptionOrOperand);

		return option.readValue(argumentIt);
	}

	shared actual String?|ParseException readOptionalValue() {
		"No current option set or at the end of the option list. Make sure to call [[AbstractOptionReader.read]] first!"
		assert (exists option = this.currentOptionOrOperand);

		return option.readOptionalValue(argumentIt);
	}
}
