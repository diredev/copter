import at.dire.copter.parse.core {
	ValueParserFactory,
	ValueParser
}

import ceylon.collection {
	HashMap,
	unlinked
}
import ceylon.language.meta.declaration {
	Module
}
import ceylon.language.meta.model {
	Type,
	Class
}

"Holds singleton instances of [[at.dire.copter.parse.core::ValueParserFactory]] and [[at.dire.copter.parse.core::ValueParser]].

 Contains a few predefined parsers. Additional parsers and factories are discovered using service providers."
shared class ValueParserProvider(
	"List of modules used to lookup parsers."
	shared {Module*} hostModules) {

	"Contains all available [[ValueParserFactory]] registered as a [[service]] in the current and all specified [[modules|ValueParserProvider.hostModules]].
	 These are sorted by [[ValueParserFactory.priority]]."
	late value allParserFactories = expand({ for(hostModule in hostModules) hostModule.findServiceProviders(`ValueParserFactory`) })
										.sort(byDecreasing(ValueParserFactory.priority));

	"Contains all [[ValueParser]] that have been made available as a [[service]]."
	late value allServicedParers = expand({ for(hostModule in hostModules) hostModule.findServiceProviders(`ValueParser<>`) }).sequence();

	"All available parsers by type. Includes some default parsers."
	value parsersByType = HashMap<Type<Anything>, ValueParser<>> {
		stability = unlinked;

		`String`->stringParser,
		`String[]`->stringSequenceParser,
		`List<String>`->stringSequenceParser,
		`{String*}`->stringSequenceParser,
		`String?[]`->nullableStringSequenceParser,
		`List<String?>`->nullableStringSequenceParser,
		`{String?*}`->nullableStringSequenceParser,
		`Boolean`->booleanParser,
		`Integer`->integerParser,
		`Float`->floatParser,
		`Null`->nullParser
	};

	"Map of types of parsers together with an instance each. Used as a simple singleton logic."
	value parserInstances = HashMap<Class<ValueParser<>>, ValueParser<>>(unlinked);

	"Creates and returns a parser of the given type, holding a single instance for each of them."
	shared ValueParser<Result> getParserInstance<out Result = Anything>(Class<ValueParser<Result>> parserType) {
		value existingInstance = parserInstances[parserType];

		if(exists existingInstance) {
			assert(is ValueParser<Result> existingInstance);
			return existingInstance;
		}

		// Not found. Create an instance.
		log.debug(()=>"Creating new singleton instance of value parser type '``parserType``'.");
		value newInstance = parserType.apply();
		parserInstances.put(parserType, newInstance);
		return newInstance;
	}

	"Call this to register your own parser for the given type."
	shared void registerParser<Result = Anything>(Type<Result> resultType, ValueParser<Result> parserType) {
		log.debug(()=>"Manually registering parser '``parserType``' for result type '``resultType``'");
		parsersByType.put(resultType, parserType);
	}

	"The same as [[getParser]] but uses unsafe code."
	shared ValueParser<>? getParserUnsafe(Type<> resultType) {
		value parser = `function getParser`.memberInvoke(this, [resultType], resultType);
		assert(is ValueParser<>? parser);
		return parser;
	}

	"Tries to find a parser that is able to provide the expected [[type|resultType]]. It will then create and return an
	 instance of this parser. Null is returned if no matching parser is found.

	 If no matching type is found for your object, you can eitehr
	 Note that this will use any [[ValueParserFactory]] "
	shared ValueParser<Result>? getParser<Result>(Type<Result> resultType) {
		// Do we already know a matching Parser?
		value existingParser = parsersByType.get(resultType);

		if(exists existingParser) {
			assert(is ValueParser<Result> existingParser);
			return existingParser;
		}

		// Didn't find any matching Parser. Try the list of serviced ValueParser
		for(serviceParser in allServicedParers) {
			if(is ValueParser<Result> serviceParser) {
				log.debug(()=>"Will use service parser '``serviceParser``' to handle the type '``resultType``'.");

				// Add to my hashmap.
				parsersByType.put(resultType, serviceParser);

				return serviceParser;
			}
		}

		// Didn't find any matching Parser. Try to create one using the Factories.
		for(factory in allParserFactories) {
			value newParser = factory.getInstance(this, resultType);

			if(exists newParser) {
				log.debug(()=>"Factory ``factory`` has provided the parser '``newParser``' to handle the type '``resultType``'.");

				// Add to my HashMap.
				parsersByType.put(resultType, newParser);

				assert(is ValueParser<Result> newParser);
				return newParser;
			}
		}

		// Failed to get or create a matching parser.
		log.warn(()=>"Failed to find or create a parser matching '``resultType``'.");
		return null;
	}
}

