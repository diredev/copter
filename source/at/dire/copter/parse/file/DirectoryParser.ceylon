import at.dire.copter.parse.core {
	ValueParser
}
import at.dire.copter.parse.core.parsers {
	SingleValueParser
}

import ceylon.file {
	Directory
}

"Parser for [[ceylon.file::Directory]]."
service(`interface ValueParser`)
shared class DirectoryParser() extends SingleValueParser<Directory>() {
	shared actual Directory|ParseException parseImpl(String stringValue) {
		// Get the resource. Resolve links if needed.
		value resource = parseResource(stringValue);

		if(is Directory resource) {
			return resource;
		} else {
			return ParseException("\"``stringValue``\" is not a directory.");
		}
	}
}