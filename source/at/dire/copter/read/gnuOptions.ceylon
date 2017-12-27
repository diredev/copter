import at.dire.copter.read.impl {
	GnuOptionReader
}

"Allows reading and formatting options by using the rules defined by *Gnu getopt*.

 The basic rules are:
  * Reading short options without value (`-a`).
  * Reading a group of short options (`-abc`).
  * Reading a short option with value (`-a VALUE` or `-aVALUE`), the latter form is required for optional values.
  * Reading a long option without value (`--name`).
  * Reading a long option with value (`--name VALUE` or `--name=VALUE`), the latter form is required for optional values.
  * Reading operands also includes the special value `-`.
  * Handling the special value `--` which will cause all further arguments to be considered operands."
see (`interface OptionReader`)
shared object gnuOptions satisfies OptionReaderFactory {
	createReader({String*} arguments) => GnuOptionReader(arguments);

	shared actual String formatOption(String name, Boolean readValue, Boolean valueRequired, String valueLabel) {
		value useShortName = name.size == 1;

		if (readValue) {
			if (valueRequired) {
				// Print as "-a VALUE" or "--name=VALUE"
				if (useShortName) {
					return "-``name`` ``valueLabel``";
				} else {
					return "--``name``=``valueLabel``";
				}
			} else {
				// Print as "-a[VALUE]" or "--name[=VALUE]"
				if (useShortName) {
					return "-``name``[``valueLabel``]";
				} else {
					return "--``name``[=``valueLabel``]";
				}
			}
		} else if (useShortName) {
			return "-" + name;
		} else {
			return "--" + name;
		}
	}
}
