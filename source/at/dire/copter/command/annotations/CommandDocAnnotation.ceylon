"Use this to annotate options, operands, command classes and even packages with a shortened documentation. This will be picked up
 by the documentation generator instead of the [[doc]]."
shared annotation CommandDocAnnotation commandDoc(
	"Display text"
	String description) => CommandDocAnnotation(description);

"Annotation class for [[commandDoc]]."
shared final annotation class CommandDocAnnotation(
	"Display text"
	shared String description)
		satisfies OptionalAnnotation<CommandDocAnnotation,Annotated> {
	string => description;
}
