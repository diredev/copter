import at.dire.copter.parse.core {
	ValueParser
}
import at.dire.copter.parse.core.parsers {
	ValueParserProvider
}

import ceylon.language.meta.declaration {
	ValueDeclaration
}
import ceylon.language.meta.model {
	Type
}

"The same as [[getParserFromAnnotationUnsafe]] but uses unsafe invocation."
ValueParser<> getParserFromAnnotationUnsafe(ValueDeclaration attributeDeclaration, Type<> attributeType, ValueParserProvider parserProvider) {
	value parser = `function getParserFromAnnotation`.invoke([attributeType], attributeDeclaration, attributeType, parserProvider);
	assert (is ValueParser<> parser);
	return parser;
}

"Return a [[ValueParserAnnotation]] for the given attribute.

 Uses [[annotations|ValueParserAnnotation]] to find a parser. If no annotation is found, we try to find or create a matching default parser.
 If that doesn't work either, we raise an exception."
ValueParser<Result> getParserFromAnnotation<Result>(ValueDeclaration attributeDeclaration, Type<Result> attributeType, ValueParserProvider parserProvider) {
	// Check if there is a specific parser assigned.
	value parserAnnotation = attributeDeclaration.annotations<ValueParserAnnotation>().first;

	if (exists parserAnnotation) {
		return parserProvider.getParserInstance<Result>(parserAnnotation.type.classApply<ValueParser<Result>>());
	} else {
		value parser = parserProvider.getParser<Result>(attributeType);

		"Failed to find a matching parser for type \"``attributeType``\"."
		assert (exists parser);

		return parser;
	}
}
