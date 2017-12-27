import at.dire.copter.parse.core {
	ValueParserFactory,
	ValueParser
}

import ceylon.language.meta.model {
	Type,
	Interface
}

"Factory that creates parsers for [[maps|Map]]."
service(`interface ValueParserFactory`)
shared class MapParserFactory() satisfies ValueParserFactory {
	shared actual ValueParser<Map<>>? getInstance(ValueParserProvider allParsers, Type<Anything> forType) {
		// Only relevant for Maps.
		if(!is Interface<Map<>> forType) {
			return null;
		}

		// Get Parsers for key and value types.
		value keyType = forType.typeArgumentList[0];
		assert(exists keyType);
		value keyParser = allParsers.getParserUnsafe(keyType);

		if(!exists keyParser) {
			return null;
		}

		assert(is ValueParser<Object> keyParser);

		value itemType = forType.typeArgumentList[1];
		assert(exists itemType);
		value itemParser = allParsers.getParserUnsafe(itemType);

		if(!exists itemParser) {
			return null;
		}

		// Create a parser instance of the correct type.
		value realParser = `class MapParser`.instantiate([keyType, itemType], keyParser, itemParser);
		assert(is MapParser<> realParser);
		return realParser;
	}

	priority = -200;
}