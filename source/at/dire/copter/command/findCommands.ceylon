import at.dire.copter.command.annotations {
	CommandAnnotation
}

import ceylon.language.meta.declaration {
	ClassDeclaration,
	Module,
	Package
}

"Searches the given modules or packages for [[commands|at.dire.copter.command::Command]]."
shared {SubCommand*} findCommands(Module|Package* sources) {
	return expand({ for (source in sources) if (is Module source) then findCommands(*source.members) else findCommandsInPackage(source) });
}

"Searches the given modules or packages for [[commands|at.dire.copter.command::Command]]."
{SubCommand*} findCommandsInPackage(Package fromPackage) {
	return { for (value commandType in fromPackage.annotatedMembers<ClassDeclaration,CommandAnnotation>())
			if (exists annotation = commandType.annotations<CommandAnnotation>().first)
				annotation.name -> commandType.classApply<Command>() };
}
