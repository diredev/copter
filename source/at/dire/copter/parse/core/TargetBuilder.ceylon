import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Used by the [[OptionParser]] to construct option objects given all attributes together with their values.

 Note that defaulted attributes may not be set by the parser at all."
see (`class DefaultBuilder`)
shared interface TargetBuilder<out Result> {
	"Apply the value of a parsed attribute."
	shared formal void apply(
		"The attribute to apply the value to."
		ValueDeclaration attribute,
		"Attribute value."
		Anything val);

	"Create and return the actual object."
	shared formal Result build();
}
