import at.dire.copter.parse.core {
	ValueParser
}
import at.dire.copter.parse.core.parsers {
	SingleValueParser
}

import ceylon.file {
	Link
}

"Parser for [[ceylon.file::Link]].

 Use this if you need to get a [[ceylon.file::Link]]. You may want to use [[ExistingResourceParser]] to get any type of resource."
service(`interface ValueParser`)
shared class LinkParser() extends SingleValueParser<Link>() {
	shared actual Link|ParseException parseImpl(String stringValue) {
		// Parse resource. Do NOT handle symbolic links though.
		value resource = parseResource(stringValue, false);

		if(is Link resource) {
			return resource;
		} else {
			return ParseException("\"``stringValue``\" is not a symbolic link.");
		}
	}
}