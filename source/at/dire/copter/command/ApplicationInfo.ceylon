"Provides information on an application.

 This is used to output documentation, licensing and version information."
see(`function createAppInfoFromModule`)
shared class ApplicationInfo(
	"Executable name of this application."
	shared String executableName,
	"A human readable title for your application."
	String title,
	"The version of your application. This should probably match your module version."
	String version,
	"A longer description of this application."
	shared String description,
	"Copyright information of your applicaiton. May have multiple lines."
	shared {CopyrightNotice*} copyrightInfo = {},
	"A short license info for your application as well as statements on free-software, etc."
	shared String? licenseInfo = null,
	"If your application is part of a bigger application, return the parent application here. Optional."
	shared ApplicationInfoRef? parentApplication = null) extends ApplicationInfoRef(title, version) {}
