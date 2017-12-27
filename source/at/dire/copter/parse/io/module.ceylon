"Extension module for ***Copter*** that provides support for `ceylon.io`.

 Add this module to your classpath to handle [[paths|ceylon.io::FileDescriptor]] and standard input."
native("jvm")
module at.dire.copter.parse.io "1.0.0" {
	shared import ceylon.io "1.3.3";
	shared import at.dire.copter.parse.core "1.0.0";
}
