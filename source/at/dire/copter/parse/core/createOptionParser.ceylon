import at.dire.copter.parse.core.annotations {
	getMappedOptionsFromAnnotations
}
import at.dire.copter.parse.core.parsers {
	ValueParserProvider
}

import ceylon.language.meta.model {
	Class
}

"Convenience method that will create an [[OptionParser]] for the given [[class|forClass]]."
shared OptionParser<Result,SpecialOption> createOptionParser<Result, SpecialOption>(
	"The class to be serialized."
	Class<Result> forClass,
	"Optional map of special options to handle in addition to the object's options."
	Map<String,SpecialOption> specialOptions = emptyMap) given Result satisfies Object given SpecialOption satisfies Object {

	value valueParserProvider = ValueParserProvider({ forClass.declaration.containingModule });
	value mappedOptions = getMappedOptionsFromAnnotations<Result,SpecialOption>(forClass, valueParserProvider, specialOptions);
	return OptionParser(mappedOptions);
}
