import ceylon.language.meta.declaration {
	Module
}

//TODO: Ceylon 1.3.4/1.4.0: Use "label" annotation provided by Ceylon instead. See GitHub Issue #7193.

"Annotate your module with this annotation to set a readable title for your application.

 Used to create command documentation."
shared annotation LabelAnnotation label(
	"Display text"
	String label) => LabelAnnotation(label);

"Annotation class for [[label]]."
shared final annotation class LabelAnnotation(
	"Display text"
	shared String label) satisfies OptionalAnnotation<LabelAnnotation,Module> {

	string => label;
}
