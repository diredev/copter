"Reference to an application."
shared class ApplicationInfoRef(
	"A human readable name for your application."
	shared String name,
	"The version of your application. This should probably match the parent module version."
	shared String version) {

	string => "``name`` ``version``";
}
