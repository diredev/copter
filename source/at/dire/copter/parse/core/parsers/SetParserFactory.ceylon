import at.dire.copter.parse.core {
	ValueParserFactory,
	ValueParser
}

import ceylon.language.meta.model {
	Type,
	Interface
}

"Creates parsers to handle [[sets|Set]]."
service(`interface ValueParserFactory`)
shared class SetParserFactory() satisfies ValueParserFactory {
	shared actual ValueParser<Set<>>? getInstance(ValueParserProvider allParsers, Type<Anything> forType) {
		// Only for Sets.
		if(!is Interface<Set<>> forType) {
			return null;
		}

		// Get the Set's item type.
		value itemType = forType.typeArgumentList.first;

		"Failed to determine item type of Set type ``forType``."
		assert(exists itemType);

		// Get a parser for my item.
		value itemParser = allParsers.getParserUnsafe(itemType);

		"Failed to create a parser for item type ``itemType`` of the set type ``forType``."
		assert(exists itemParser);

		"Null is not valid item type for sets, cannot use item parser ``itemParser``."
		assert(is ValueParser<Object> itemParser);

		// Create an instance of the correct type, pass the itemParser as argument.
		value sequenceParser = `class SequenceParser`.instantiate([itemType], itemParser);
		value realParser = `class SetParser`.instantiate([itemType], sequenceParser);
		assert(is SetParser<> realParser);
		return realParser;
	}

	priority = -210;
}