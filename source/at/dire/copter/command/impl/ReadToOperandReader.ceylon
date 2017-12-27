import at.dire.copter.read {
	OptionReader,
	OptionOrOperand
}

"Decorator for [[at.dire.copter.core.read:OptionReader]] that will only read to the very first (if any) operand.

 This operand is returned normally but reading is stopped afterwards. You can use the original OptionReader to continue
 reading the rest of the command line afterwards."
shared class ReadToOperandReader("The actual reader" OptionReader inner) satisfies OptionReader {
	"Set to true once the first operand has been read."
	variable Boolean isFinished = false;

	shared actual OptionOrOperand|Finished read() {
		// Abort if we have already read an operand.
		if(isFinished) {
			return finished;
		}

		value name = inner.read();

		if(is OptionOrOperand name, name.operand) {
			// When the first operand was read, we only return finished from this point on.
			isFinished = true;
		}

		return name;
	}

	readValue() => inner.readValue();
	readOptionalValue() => inner.readOptionalValue();
}
