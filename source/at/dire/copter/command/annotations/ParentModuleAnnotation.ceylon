import at.dire.copter.command {
	ApplicationInfoRef
}

import ceylon.language.meta.declaration {
	Module
}

"Use this annotation to describe the parent application of your module. This can be used to describe your [[ApplicationInfoRef]]."
shared annotation ParentModuleAnnotation parentModule(String name, String version) => ParentModuleAnnotation(name, version);

"Annotation class for [[parentModule]]."
shared final annotation class ParentModuleAnnotation("Parent module name." shared String name, "Parent module version." shared String version) satisfies OptionalAnnotation<ParentModuleAnnotation, Module> {
	"Returns an [[ApplicationInfoRef]] matching this annotation."
	shared ApplicationInfoRef toApplication() => ApplicationInfoRef(name, version);

	string => "``name`` ``version``";
}
