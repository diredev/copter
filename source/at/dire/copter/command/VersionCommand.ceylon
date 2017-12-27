import at.dire.copter.command.annotations {
	commandDoc
}
import at.dire.copter.parse.core.inject {
	optionInject
}

"Print the current [[at.dire.copter.command::Application]] name, version, copyright and license information to the console.

 This is commonly used as the special-option *--version*, but may also be used as a sub-command, or both.

 The format used here is derived from the [Gnu Coding Standards](https://www.gnu.org/prep/standards/standards.html#g_t_002d_002dversion). All of the
 information is taken from the current [[at.dire.copter.command::ApplicationInfo]]."
commandDoc("Print version information and exit.")
shared class VersionCommand(optionInject CommandContext context) satisfies Command {
	shared actual Integer run() {
		// The first line is the name of the application and version.
		value appInfo = context.application.getInfo();
		value output = StringBuilder();
		output.append(appInfo.name);

		// If a parent application was specified, print it in brackets.
		if(exists parentApp = appInfo.parentApplication) {
			output.append(" (").append(parentApp.name);

			// Print parent version only if different.
			if(parentApp.version != appInfo.version) {
				output.appendSpace().append(parentApp.version);
			}

			output.append(")");
		}

		// Write the version.
		output.appendSpace().append(appInfo.version).appendNewline();

		// Second line (or more) is copyright information.
		for(copyright in appInfo.copyrightInfo) {
			output.append(copyright.string).appendNewline();
		}

		// Second line is the license info, if any
		if(exists licenseInfo = appInfo.licenseInfo) {
			output.append(licenseInfo).appendNewline();
		}

		print(output.string);

		return 0;
	}
}
