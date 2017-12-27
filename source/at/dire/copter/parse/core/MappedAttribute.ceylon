import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Attribute mapped to an option or an operand."
shared class MappedAttribute(
	"Display name for the attribute."
	shared String displayName,
	"The actual value to apply to."
	shared ValueDeclaration targetValue,
	"The parser used to interpret the Option's value"
	shared ValueParser<> parser,
	"True if we are should pass an empty list of values to the [[parser|ValueParser]] when no value is given for an option."
	shared Boolean applyEmpty = true) {

	string => displayName;
	hash => targetValue.hash;
}
