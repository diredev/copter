import at.dire.copter.parse.core.parsers {
	CaseValueParserFactory
}

import ceylon.language.meta.declaration {
	ValueConstructorDeclaration,
	ValueDeclaration
}

"Apply to case values or value constructors to make them parseable."
see (`class CaseValueParserFactory`)
shared annotation OptionValueAnnotation optionValue(
	"Value on the command line for this enumerated value. If no value is entered here, one is generated from the name of the element."
	String name = "\0\0\0\0default\0\0\0") => OptionValueAnnotation(name);

"Annotation class for [[optionValue]]."
shared final annotation class OptionValueAnnotation(String nameArg)
		satisfies OptionalAnnotation<OptionValueAnnotation,ValueDeclaration|ValueConstructorDeclaration> {

	"Returns the name of this value or null, if none was given by the user."
	shared String? name {
		if (nameArg != "\0\0\0\0default\0\0\0") {
			return nameArg;
		} else {
			return null;
		}
	}
}
