import at.dire.copter.parse.core.annotations {
	getMappedOptionsFromAnnotations
}
import at.dire.copter.read.collect {
	AvailableOption
}

import ceylon.language.meta.model {
	Class
}

"This class represents a collection of all possible options and operands of a class as well as any special options
 that may apply and additional sub-groups.

 This is used as input for the [[OptionParser]]. While you can create this object in code if you want,
 it probably makes more sense to apply annotations to your class and use [[at.dire.copter.parse.core.annotations::getMappedOptionsFromAnnotations]] instead."
see (`class OptionParser`, `function getMappedOptionsFromAnnotations`)
shared class MappedOptions<out Result=Object, out SpecialOption=Nothing>(
	"The class this mapper was created for."
	shared Class<Result> forClass,
	"Returns all options and special-options."
	shared [AvailableOption<MappedAttribute|SpecialOption>*] options,
	"Returns all operands. These may not be ordered."
	shared [OrderedOperand*] operands,
	"Returns all known option groups (sub-options)."
	shared [MappedGroup*] groups = [],
	"The list of special options together with their names."
	shared Map<String,SpecialOption> specialOptions = emptyMap) given Result satisfies Object {

	"Return all of the mapped fields from all options and operands. Does not include any special options or option-groups."
	shared default {MappedAttribute*} values => { for (option in options) if (is MappedAttribute key = option.key) key }
		.chain(operands.map(OrderedOperand.key));

	"Return the lists of all options and operands, including those of [[sub-options|MappedOptions.groups]]. They are returned
	 in their [[usage-order|OrderedOperand.order]]."
	shared [[AvailableOption<MappedAttribute|SpecialOption>*], [OrderedOperand*]] getAllOptionsAndOperands() {
		variable {AvailableOption<MappedAttribute|SpecialOption>*} allOptions = options;
		variable {OrderedOperand*} allOperands = operands;

		// Also add all option groups recursively. They will be used to evaluate the command line together.
		for (value group in groups) {
			if (exists groupMapper = group.innerMapper) {
				value subOptionsAndOperands = groupMapper.getAllOptionsAndOperands();

				allOptions = allOptions.chain(subOptionsAndOperands[0]);
				allOperands = allOperands.chain(subOptionsAndOperands[1]);
			}
		}

		// Operands have to be sorted. After everything is loaded we order the Operand list.
		allOperands = allOperands.sort(byIncreasing(OrderedOperand.order));

		return [allOptions.sequence(), allOperands.sequence()];
	}
}
