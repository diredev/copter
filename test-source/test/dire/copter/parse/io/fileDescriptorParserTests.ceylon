import at.dire.copter.parse.io {
	FileDescriptorParser
}

import ceylon.file {
	temporaryDirectory
}
import ceylon.io {
	standardInput,
	FileDescriptor
}
import ceylon.test {
	test,
	assertEquals
}

"Test reading files, both existing and non-existing ones."
test
void testParseFile() {
	value parser = FileDescriptorParser();
	value tempFile = temporaryDirectory.TemporaryFile("copter", null);

	// Parse an existing file.
	value parsedDescriptor = parser.parseSingle(tempFile.path.string);
	assert(is FileDescriptor parsedDescriptor);
	parsedDescriptor.close();

	// Remove the temporary file.
	tempFile.delete();

	// Parse missing file.
	value missingFile = parser.parseSingle(tempFile.path.string);
	assert(is ParseException missingFile);

}

"Test parsing the special value `-`, which should return the standard input."
test
void testStandardInput() {
	value parser = FileDescriptorParser();
	value result = parser.parseSingle("-");

	assertEquals(result, standardInput);
}