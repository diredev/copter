"Option or operand read from command-line arguments."
see (`class AbstractOptionReader`, `class Operand`)
shared interface OptionOrOperand {
	"Returns the name of the options the way it was read, with prefixes intact. Returns the value for operands.

	 Use this for display purposes only."
	shared formal String readName;

	"The name of the option without prefix characters. Returns an empty string for operands."
	shared formal String name;

	"Return if we are dealing with an operand."
	shared formal Boolean operand;

	"Read the value for this Option or Operand. This could also return [[ParseException]] depending on the implementation and if the option is missing a value."
	see (`function readOptionalValue`)
	shared formal String|ParseException readValue(
		"Use this to get additional argument values if necessary."
		Iterator<String> moreArguments);

	"Similar to [[OptionOrOperand.readValue]] but will allow no value to be given, which results in null being return."
	shared formal String?|ParseException readOptionalValue(
		"Use this to get additional argument values if necessary."
		Iterator<String> moreArguments);

	"Return true here if you are able to read additional values for this option using [[OptionOrOperand.readValue]].
	 Use this to allow reading multiple short options as a group."
	shared default Boolean readNextName() => false;
}
