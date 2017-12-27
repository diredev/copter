import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Mark an attribute as a group of options.

 Applying this annotation to an object will collect all [[options|option]] and [[operands|operand]] on this
 class (and all sub-groups if any) to form a single list of options and operands."
shared annotation OptionGroupAnnotation optionGroup(
	"True if this group will be merged with the parent group when outputting help, etc."
	Boolean absorbed = false) => OptionGroupAnnotation(absorbed);

"Annotation class for [[optionGroup]]."
shared final annotation class OptionGroupAnnotation("True if the group will be merged into parent group." shared Boolean absorbed)
		satisfies OptionalAnnotation<OptionGroupAnnotation,ValueDeclaration>  {
}
