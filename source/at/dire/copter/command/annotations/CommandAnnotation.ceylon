import at.dire.copter.command {
	findCommands
}

import ceylon.language.meta.declaration {
	ClassDeclaration
}

"Identify [[commands|at.dire.copter.command::Command]] for use by an [[at.dire.copter.command::Application]]."
see (`function findCommands`)
shared annotation CommandAnnotation command(
	"Name this command is called by."
	String name) => CommandAnnotation(name);

"Annotation class for [[command]]."
shared final annotation class CommandAnnotation(
	"Name this command is called by."
	shared String name)
		satisfies OptionalAnnotation<CommandAnnotation,ClassDeclaration> {

	string => name;
}
