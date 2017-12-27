import at.dire.copter.command.annotations {
	SpecialOptionAnnotation
}

import ceylon.language.meta.declaration {
	ClassDeclaration
}
import ceylon.language.meta.model {
	Class
}

"Get all of the special options [[declared|at.dire.copter.command.annotations::specialOption]] on the given type in addition
 to those provided as arguments."
shared Map<String,Class<Command>> getSpecialOptions(
	"Class to get annotations from."
	ClassDeclaration declaration,
	"Other special options."
	{SubCommand*} specialOptions = {})  {

	value annotatedSpecialOptions = declaration.annotations<SpecialOptionAnnotation>();
	value specialOptionItems = annotatedSpecialOptions.map((specialOption) => specialOption.name -> specialOption.commandClass.classApply<Command>());

	return map(specialOptionItems.chain(specialOptions));
}
