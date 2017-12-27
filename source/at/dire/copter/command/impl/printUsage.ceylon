import at.dire.copter.command {
	ApplicationInfo,
	Command
}
import at.dire.copter.parse.core {
	MappedOptions
}
import at.dire.copter.read {
	OptionFormatter
}

import ceylon.language.meta.model {
	Class
}

"Print usage information for the given application."
shared void printUsage(
	"Application information."
	ApplicationInfo appInfo,
	"Sub command executed, if any."
	String? subCommand,
	"Available options"
	MappedOptions<Anything,Class<Command>> mappedOptions,
	"To format options."
	OptionFormatter formatter,
	"Additional data to print."
	String addedOutput = "") {

	print("Usage: ``appInfo.executableName`` ``subCommand else ""````getUsage(mappedOptions, formatter)`` ``addedOutput``");
}
