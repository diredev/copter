"Forward-only reader for command line options and operands.

 Check the module's description for more details and a usage example."
see (`interface OptionReaderFactory`, `class AbstractOptionReader`, `value emptyOptionReader`)
shared interface OptionReader {
	"Read the next option or operand on the command line. This will either return the next [[option or operand|OptionOrOperand]] or [[finished]]
	 when reading is done.

	 Use [[OptionReader.readValue]] or [[OptionReader.readOptionalValue]] after this to get the value of the current option or the value of the operand."
	shared formal OptionOrOperand|Finished read();

	"Use this after [[OptionReader.read]] to get the value of the current option or operand.

	 Will return a [[ParseException]] when no value is given or reading the option value fails."
	shared formal String|ParseException readValue();

	"Similar to [[OptionReader.readValue]] but will not require a value for options.

	 Null is returned when the user did not specify a value. This acts identical to [[OptionReader.readValue]] for operands."
	shared formal String?|ParseException readOptionalValue();
}
