import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Apply this annotation to an Attribute together with [[option]] to make the Option's value optional, i.e. the user is not required to specify a value.
 Use [[OptionalValueAnnotation.default]] to set the value that will be used when no value is given by the user. If not, a sane
 default value or Null is used instead."
shared annotation OptionalValueAnnotation optionalValue(
	"The default value to apply when no value was given by the user. Leave the default to apply [[null]] or a sane default value."
	String default = "\0\0\0\0default\0\0\0") => OptionalValueAnnotation(default);

"Annotation class for [[optionalValue]]."
shared final annotation class OptionalValueAnnotation(String defaultArg)
		satisfies OptionalAnnotation<OptionalValueAnnotation,ValueDeclaration> {
	"The default optional value. Returns [[null]] if not specified."
	shared String? default => (defaultArg != "\0\0\0\0default\0\0\0" then defaultArg);
}
