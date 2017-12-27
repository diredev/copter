import at.dire.copter.parse.core {
	ValueParser
}
import at.dire.copter.parse.core.parsers {
	SingleValueParser
}

import ceylon.file {
	defaultSystem,
	Nil
}
import ceylon.io {
	ReadableFileDescriptor,
	standardInput,
	newOpenFile
}

"Parse command line arguments into [[ceylon.io::ReadableFileDescriptor]].

 Also handles the special value `-` by returning the [[ceylon.io::standardInput]].
 Note that this will only work if the given file exists. Use the classes in `at.dire.copter.parse.file`
 instead to handle paths, existing or not."
service(`interface ValueParser`)
shared class FileDescriptorParser() extends SingleValueParser<ReadableFileDescriptor>() {
	shared actual ReadableFileDescriptor|ParseException parseImpl(String stringValue) {
		// Use standard input when the special value "-" is given.
		if(stringValue == "-") {
			return standardInput;
		}

		// Treat as a file otherwise.
		value filePath = defaultSystem.parsePath(stringValue);
		value fileResource = filePath.resource;

		// Only existing files.
		if(is Nil fileResource) {
			return ParseException("File ``stringValue`` does not exist.");
		}


		return newOpenFile(filePath.resource);
	}
}