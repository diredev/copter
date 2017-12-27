import at.dire.copter.parse.core {
	ValueParserFactory
}
import at.dire.copter.parse.core.annotations {
	OptionValueAnnotation
}
import at.dire.copter.parse.core.util {
	toOptionName
}

import ceylon.language.meta {
	type,
	classDeclaration
}
import ceylon.language.meta.model {
	Type,
	Class
}

"This method returns value constructors or case values for the given type that are annotated using [[at.dire.copter.parse.core.annotations::OptionValueAnnotation]]"
Map<String,Result>? getNameCaseValues<out Result>(Class<Result> forClass) {
	// Try value constructors.
	value valueConstructors = forClass.getValueConstructors(`OptionValueAnnotation`);

	if(nonempty valueConstructors) {
		return map { for(valueConstructor in valueConstructors) if(exists annotation = valueConstructor.declaration.annotations<OptionValueAnnotation>().first)
			if(is Result actualValue = valueConstructor.declaration.get())
			(annotation.name else toOptionName(valueConstructor.declaration.name) )->actualValue };
	}

	// Try case values instead.
	value caseValues = forClass.caseValues;

	if(nonempty caseValues) {
		return map { for(caseValue in caseValues)
			if(exists valueDeclaration = classDeclaration(caseValue).objectValue)
			if(exists annotation = valueDeclaration.annotations<OptionValueAnnotation>().first)
			(annotation.name else toOptionName(type(caseValue).declaration.name))->caseValue };
	}

	// Failed to find a matching cases.
	return null;
}

"The same as [[getNameCaseValues]] but called without generics."
Map<String>? getNameCaseValuesUnsafe(Class<> forClass) {
	value result = `function getNameCaseValues`.invoke([forClass], forClass);
	assert(is Map<String>? result);
	return result;
}

"Factory for [[CaseValueParser]] used to handle both case values and value constructors.

 Value constructors and case values both have to be annotated using [[at.dire.copter.parse.core.annotations::optionValue]] to be picked up."
service(`interface ValueParserFactory`)
shared class CaseValueParserFactory() satisfies ValueParserFactory {
	shared actual CaseValueParser<>? getInstance(ValueParserProvider allParsers, Type<> forType) {
		if(!is Class<> forType) {
			return null;
		}

		// Get a map of usable values. Handles both case values as well as value constructors.
		value namedValues = getNameCaseValuesUnsafe(forType);

		if(!exists namedValues) {
			// No case values found.
			return null;
		}

		// Create a new parser.
		value instance = `class CaseValueParser`.instantiate([forType], namedValues);
		assert(is CaseValueParser<> instance);
		return instance;
	}

	priority => -300;
}