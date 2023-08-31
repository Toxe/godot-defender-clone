class_name Game extends Node


func _ready():
    update_window_title()
    load_level("main")


func load_level(level_name: String):
    var level = load("res://scenes/levels/%s.tscn" % level_name).instantiate() as Node
    add_child(level)


func update_window_title():
    get_window().title = "Godot Defender Clone    [milestone 4, %d FPS]" % [Performance.get_monitor(Performance.TIME_FPS)]


func _on_update_window_title_timer_timeout():
    update_window_title()
