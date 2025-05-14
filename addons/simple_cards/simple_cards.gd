@tool
extends EditorPlugin

const CARD_GLOBAL = "CardGlobal"

func _enter_tree():
	add_autoload_singleton(CARD_GLOBAL, "res://addons/simple_cards/scripts/card_global.gd")


func _exit_tree():
	remove_autoload_singleton(CARD_GLOBAL)
