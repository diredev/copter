import at.dire.copter.parse.core {
	ValueParser,
	ValueParserFactory
}
import at.dire.copter.parse.core.util {
	getCaseTypesOf
}

import ceylon.language.meta.model {
	Type,
	UnionType
}

"This utility method returns a list of parsers matching the case types of the
 given union type. These are also sorted by [[at.dire.copter.parse.core::ValueParser.priority]]."
ValueParser<Result>[] getParsersForUnionType<Result>(ValueParserProvider allParsers, UnionType<Result> forType) {
	value unionTypes = getCaseTypesOf(forType);
	value unionParsers = { for(unionType in unionTypes) if(exists parser = allParsers.getParser(unionType)) parser };
	return unionParsers.sort(byDecreasing(ValueParser<>.priority));
}

"The same as [[getParsersForUnionType]] but called without generics."
ValueParser<>[] getParsersForUnionTypeUnsafe(ValueParserProvider allParsers, UnionType<> forType) {
	value result = `function getParsersForUnionType`.invoke([forType], allParsers, forType);
	assert(is ValueParser<>[] result);
	return result;
}

"This factory is used to create [[UnionTypeValueParser]] that will use one of several parsers to parse the different possible
 values of a union type.

 Parsers are sorted by [[at.dire.copter.parse.core::ValueParser.priority]] to make sure that the most reasonable parser is used first."
service(`interface ValueParserFactory`)
shared class UnionTypeValueParserFactory() satisfies ValueParserFactory {

	shared actual ValueParser<>? getInstance(ValueParserProvider allParsers, Type<Anything> forType) {
		// Is this a union type?
		if(!is UnionType<> forType) {
			return null;
		}

		// Collect parsers for all case types.
		value caseParsers = getParsersForUnionTypeUnsafe(allParsers, forType);

		"Failed to find any parsers matching ``forType``."
		assert(nonempty caseParsers);

		// Create a matching parser using a non-generic call.
		value allowNull = caseParsers.contains(nullParser);
		Object realParser;

		if(allowNull) {
			// Force "null" to be our sane value if we allow null. Necessary because nullParser would have the lowest priority otherwise.
			realParser = `class UnionTypeValueParser`.instantiate([forType], caseParsers, nullParser);
		} else {
			realParser = `class UnionTypeValueParser`.instantiate([forType], caseParsers);
		}

		assert(is UnionTypeValueParser<> realParser);
		return realParser;
	}

	priority => -10;
}