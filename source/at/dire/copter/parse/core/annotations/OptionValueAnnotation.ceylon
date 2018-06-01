import at.dire.copter.parse.core.parsers {
	CaseValueParserFactory
}

import ceylon.language.meta.declaration {
	ValueConstructorDeclaration,
	ValueDeclaration
}

"Apply to case values or value constructors to make them parseable. You may specify multiple names here."
see (`class CaseValueParserFactory`)
shared annotation OptionValueAnnotation optionValue(
	"Allowed values on the command line for this enumerated value. If no value is entered here, one is generated from the name of the element."
	String* names) => OptionValueAnnotation(names);

"Annotation class for [[optionValue]]."
shared final annotation class OptionValueAnnotation(shared [String*] names)
		satisfies OptionalAnnotation<OptionValueAnnotation,ValueDeclaration|ValueConstructorDeclaration> {
}
