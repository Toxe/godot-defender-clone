class_name Game extends Node


func _ready():
    load_level("main")


func load_level(level_name: String):
    var level = load("res://scenes/levels/%s.tscn" % level_name).instantiate() as Node
    add_child(level)
