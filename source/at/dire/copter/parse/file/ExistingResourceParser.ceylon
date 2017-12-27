import at.dire.copter.parse.core {
	ValueParser
}
import at.dire.copter.parse.core.parsers {
	SingleValueParser
}

import ceylon.file {
	ExistingResource
}

"Parser for [[file system resources|ceylon.file::Resource]]. Will fail when the given path does not point to a file, directory or link.

 Note that this parser will not resolve symbolic links automatically."
service(`interface ValueParser`)
shared class ExistingResourceParser() extends SingleValueParser<ExistingResource>() {
	shared actual ExistingResource|ParseException parseImpl(String stringValue) {
		value resource = parseResource(stringValue, false);

		if(is ExistingResource resource) {
			return resource;
		} else {
			return ParseException("\"``stringValue``\" does not exist.");
		}
	}
}