import ceylon.language.meta.declaration {
	ValueDeclaration,
	ClassDeclaration
}

"Use this annotation to define your own Parser for the values entered by the user.
 If you do not specify this, the system will try to select a parser automatically."
shared annotation ValueParserAnnotation valueParser(
	"The type of the parser. Has to be a [[at.dire.copter.parse.core::ValueParser]]."
	ClassDeclaration type) => ValueParserAnnotation(type);

"Annotation class for [[valueParser]]."
shared final annotation class ValueParserAnnotation(
	"The parser type."
	shared ClassDeclaration type)
		satisfies OptionalAnnotation<ValueParserAnnotation,ValueDeclaration> {
}
