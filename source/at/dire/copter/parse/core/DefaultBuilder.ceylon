import ceylon.collection {
	HashMap,
	unlinked
}
import ceylon.language.meta.declaration {
	ValueDeclaration
}
import ceylon.language.meta.model {
	Class
}

"This is the default builder implementation. It collects all values for an option object and creates a new instance using the
 default constructor and named arguments."
shared class DefaultBuilder<out Result>(Class<Result> forClass) satisfies TargetBuilder<Result> {
	"A list of all [[applied|DefaultBuilder.apply]] values."
	value paramMap = HashMap<ValueDeclaration,Anything>(unlinked);

	apply(ValueDeclaration attribute, Anything val) => paramMap.put(attribute, val);
	build() => forClass.namedApply({ for (entry in paramMap) entry.key.name->entry.item });
}