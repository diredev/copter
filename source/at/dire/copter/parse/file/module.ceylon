"Extension module for ***Copter*** that provides support for `ceylon.file`.

 Add this module to your classpath to handle [[paths|ceylon.file::Path]], [[resources|ceylon.file::Resource]], etc."
native("jvm")
module at.dire.copter.parse.file "1.0.0" {
	shared import ceylon.file "1.3.3";
	shared import at.dire.copter.parse.core "1.0.0";
}
