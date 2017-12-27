import ceylon.collection {
	HashMap
}

"A variant of [[map]] that, instead of choosing an item on duplicate keys, will raise an exception."
shared Map<Key,Item> mapWithoutDuplicates<Key, Item>({<Key->Item>*} stream) given Key satisfies Object {
	value map = HashMap<Key, Item>();
	
	for(Key->Item entry in stream) {
		value existingItem = map.put(entry.key, entry.item);
		
		"An item with the key \"``entry.key``\" already exists."
		assert(!exists existingItem);
	}
	
	return map;
}