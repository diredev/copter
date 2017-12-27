import at.dire.copter.parse.core {
	ValueParser
}
import at.dire.copter.parse.core.parsers {
	SingleValueParser
}

import ceylon.file {
	Path,
	defaultSystem
}

"Parser for [[ceylon.file::Path]]."
service(`interface ValueParser`)
shared class PathParser() extends SingleValueParser<Path>() {
	parseImpl(String stringValue) => defaultSystem.parsePath(stringValue);
}
