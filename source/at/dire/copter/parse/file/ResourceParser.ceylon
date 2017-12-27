import at.dire.copter.parse.core {
	ValueParser
}
import at.dire.copter.parse.core.parsers {
	SingleValueParser
}

import ceylon.file {
	Resource
}

"Parser for [[file system resources|ceylon.file::Resource]]."
service(`interface ValueParser`)
shared class ResourceParser() extends SingleValueParser<Resource>() {
	parseImpl(String stringValue) => parseResource(stringValue);
}