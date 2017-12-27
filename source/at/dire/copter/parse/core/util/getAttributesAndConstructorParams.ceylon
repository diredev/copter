import ceylon.language.meta.declaration {
	ValueDeclaration,
	FunctionOrValueDeclaration
}
import ceylon.language.meta.model {
	Class,
	Type
}

"Returns all shared attributes and all constructor arguments of the given type annotated with selected annotations.

 This will return tuples containing the attribute/parameter together with the type of the attribute and parameter."
shared {[ValueDeclaration, Type<>]*} getAttributesAndConstructorParams<AnnotationTypes>(Class<Anything> forClass) given AnnotationTypes satisfies Annotation {
	// Get (public) attributes
	value attributes = { for(attribute in forClass.getAttributes(`AnnotationTypes`)) [attribute.declaration, attribute.type] };

	// Add all attributes of the default constructor
	if(exists constructor = forClass.defaultConstructor) {
		value paramTypes = constructor.parameterTypes;
		value params = constructor.declaration.parameterDeclarations;

		value paramsAndTypes = mapPairs(( FunctionOrValueDeclaration first, Type<> second) => [first,second], params, paramTypes);

		//TODO: paramValue.annotated<AnnotationTypes> will not work for union types, but annotations<AnnotationTypes>() works. Probably an engine bug...
		value paramDeclarations = { for(paramAndType in paramsAndTypes) if(is ValueDeclaration paramValue = paramAndType[0], paramValue.annotations<AnnotationTypes>() nonempty) [paramValue, paramAndType[1]] };

		return attributes.chain(paramDeclarations);
	}

	return attributes;
}
