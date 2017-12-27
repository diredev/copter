import ceylon.file {
	Resource,
	defaultSystem,
	Link
}

"Return the resource for the given path. Will also handle [[symbolic links|ceylon.file::Link]]."
Resource parseResource(String stringValue, Boolean resolveLinks = true) {
	value resource = defaultSystem.parsePath(stringValue).resource;

	// Handle links automatically.
	if(resolveLinks, is Link resource) {
		return resource.linkedPath.resource;
	}

	return resource;
}
