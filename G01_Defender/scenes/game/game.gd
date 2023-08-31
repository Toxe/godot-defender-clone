class_name Game extends Node

const main_level_scene = preload("res://scenes/levels/main/main.tscn")


func _ready():
    update_window_title()
    load_level(main_level_scene)


func load_level(level_scene: Resource):
    add_child(level_scene.instantiate())


func update_window_title():
    get_window().title = "Godot Defender Clone    [milestone 4, %d FPS]" % [Performance.get_monitor(Performance.TIME_FPS)]


func _on_update_window_title_timer_timeout():
    update_window_title()
