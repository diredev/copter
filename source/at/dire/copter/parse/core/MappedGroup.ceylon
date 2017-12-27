import ceylon.language.meta.declaration {
	ValueDeclaration
}

"Maps an [[at.dire.copter.parse.core.annotations::optionGroup]] to an attribute of an object."
shared class MappedGroup(
	"The attribute that will be set to the parsing result for this group."
	shared ValueDeclaration targetValue,
	"Mapped options for the target object of the attribute. Groups missing mapped options will be initialized as null."
	shared MappedOptions<>? innerMapper,
	"If this is true then this group's options will be added to the parent group, i.e. the group will not be visible to the user as such."
	shared Boolean absorbed = false) {

	string => "Group: " + targetValue.qualifiedName;
	hash => targetValue.hash;
}
