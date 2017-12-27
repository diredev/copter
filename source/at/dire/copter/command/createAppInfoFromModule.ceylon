import at.dire.copter.command.annotations {
	LabelAnnotation,
	ParentModuleAnnotation,
	CopyrightAnnotation
}
import at.dire.copter.command.impl {
	extractDescription
}

import ceylon.language.meta.declaration {
	Module
}

"Create an [[ApplicationInfo]] from the info, documentation and annotations on the given module."
shared ApplicationInfo createAppInfoFromModule(Module forModule) {
	//TODO: Use Ceylon's "label" annotation in the future (see issue #7193)
	value labelAnnotation = forModule.annotations<LabelAnnotation>().first;
	String label;

	if(exists labelAnnotation) {
		label = labelAnnotation.label;
	} else {
		// Use a process property or fallback to module name.
		label = process.propertyValue("copter.application.title") else forModule.name ;
	}

	// Executable name is read from process proeperties if possible.
	//TODO: Use JAR/CAR name instead?? Or "java" itself?
	value executableName = process.propertyValue("copter.application.executable") else label;

	value license = forModule.annotations<LicenseAnnotation>().first?.description;
	value parentAppInfo = forModule.annotations<ParentModuleAnnotation>().first?.toApplication();
	value copyrightNotices = { for(copyright in forModule.annotations<CopyrightAnnotation>()) copyright.toCopyrightNotice() };

	return ApplicationInfo(executableName, label, forModule.version, extractDescription(forModule), copyrightNotices, license, parentAppInfo);
}
