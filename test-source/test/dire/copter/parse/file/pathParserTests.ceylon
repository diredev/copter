import at.dire.copter.parse.file {
	PathParser
}

import ceylon.file {
	temporaryDirectory,
	Path
}
import ceylon.test {
	test
}

"Test for [[at.dire.copter.parse.file::PathParser]]."
test
void testParsePath() {
	value parser = PathParser();

	// Cannot parse null.
	value nullResult = parser.parseSingle(null);
	assert(is ParseException nullResult);

	// Parse an existing path.
	value tempDir = parser.parseSingle(temporaryDirectory.path.string);
	assert(is Path tempDir);

	// Parse a (probably) non-existant path
	value subPath = tempDir.childPath("test-copter");
	value subDir = parser.parseSingle(subPath.string);
	assert(is Path subDir);
}