extends Node

#General Settings
var use_shadows: bool = true ##Sets the generation of shadows of the cards
var use_tooltips: bool = true ##Shows tooltips on cards
var play_key: String = "ui_accept" ##Input key used to play cards

##Use this array to add groups of nodes 
var target_filter: Array[String] = ["entity", "player"]


##Gets all nodes in the tagged by target_filter and puts them into an array
func get_targets() -> Array:
	var targets_dict = {}
	
	for group in target_filter:
		var temp: Array = get_tree().get_nodes_in_group(group)
		for node in temp:
			targets_dict[node] = true
	
	return targets_dict.keys()
