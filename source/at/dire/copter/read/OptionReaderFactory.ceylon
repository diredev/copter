"Can be used to create [[readers|OptionReader]] and print options."
shared interface OptionReaderFactory satisfies OptionFormatter {
	"Create a reader that matches this formatter's style."
	shared formal OptionReader createReader(
		"List of command line arguments."
		{String*} arguments);
}
