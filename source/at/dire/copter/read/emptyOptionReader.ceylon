"An [[OptionReader]] that will never read anything."
shared object emptyOptionReader satisfies OptionReader {
	read() => finished;

	shared actual Nothing readValue() {
		"Cannot read values for emptyReader."
		assert (false);
	}

	shared actual Nothing readOptionalValue() {
		"Cannot read values for emptyReader."
		assert (false);
	}
}
