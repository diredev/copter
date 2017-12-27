import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Use this to assign your own label for an option or operand. Will be used in help and error output.

 This is used when printing help for a command, e.g. if you want \"--time-style=STYLE\" in the help output, label the value with \"STYLE\"."
shared annotation ValueLabelAnnotation valueLabel(String label) => ValueLabelAnnotation(label);

"Annotation class for [[valueLabel]]."
shared final annotation class ValueLabelAnnotation(
	"Display text."
	shared String label) satisfies OptionalAnnotation<ValueLabelAnnotation,ValueDeclaration> {
	string => label;
}
