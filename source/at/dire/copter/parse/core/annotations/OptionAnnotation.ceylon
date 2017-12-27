import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Use this annotation to mark command-line options. Unlike [[flags|flag]] options require a value provided by the user. This
 value may be optional however."
shared annotation OptionAnnotation option(
	"List of names for this option. Use single letters her for short options. If you do not specify
	 a name here, a single name is created from the attribute's name."
	String+ names) => OptionAnnotation(names);

"Use this to mark command-line flags. Unlike [[options|option]] flags will not read a value and are usually used with
 Boolean attributes.

 This annotation will always set the attribute to *true*. Use [[nonFlag]] or [[customFlag]] if you need more options.
 You can also combine these annotations on the same attribute if needed."
shared annotation OptionAnnotation flag(String* names) => OptionAnnotation(names, false, "true");

"This is essentially the same as [[flag]], but will, when specified, set the annotated attribute (usually of type Boolean)
 to false instead. Note that the logic will not append any \"no-\" prefix to your attribute when you use this.

 You may also want to use [[customFlag]] to customize the value being applied. You can also combine these annotations on the same attribute if needed."
shared annotation OptionAnnotation nonFlag(String* names) => OptionAnnotation(names, false, "false");

"This annotation can be used instead of [[flag]] and [[nonFlag]]. The difference is that you can customize
 the value that will be applied to the attribute, which is usefull when the attribute is not a Boolean attribute.

 Note that you can also combine the different flag-annotations on the same attribute if necessary."
shared annotation OptionAnnotation customFlag(String[] names, String presentValue) => OptionAnnotation(names, false, presentValue);

"Annotation class used to mark options and flags."
shared final annotation class OptionAnnotation(
	"Names used for this option. Use single letters here for short options."
	shared [String*] names,
	"True if we need to read a value for this option. Set to false for flag-type options."
	shared Boolean readValue = true,
	"Change this from the default value to set a value that will be used when the option is given. See [[presentValue]]."
	String presentValueArg = "\0\0\0default\0\0\0")
		satisfies SequencedAnnotation<OptionAnnotation,ValueDeclaration> {

	"Returns the value to be used when the option is present. This will become the value used if
	 [[readValue]] is false, otherwise it will be the default value if reading a value is optional."
	shared String? presentValue => (presentValueArg != "\0\0\0default\0\0\0" then presentValueArg);

	string => names.first else "<autoname>";
}
