import at.dire.copter.parse.core {
	ValueParser
}
import at.dire.copter.parse.core.parsers {
	SingleValueParser
}

import ceylon.file {
	File
}

"Parser for [[ceylon.file::File]]."
service(`interface ValueParser`)
shared class FileParser() extends SingleValueParser<File>() {
	shared actual File|ParseException parseImpl(String stringValue) {
		// Get the resource. Resolve links if needed.
		value resource = parseResource(stringValue);

		if(is File resource) {
			return resource;
		} else {
			return ParseException("\"``stringValue``\" is not a file.");
		}
	}
}