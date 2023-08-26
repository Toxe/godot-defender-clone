extends Node


func _ready():
    update_window_title()


func update_window_title():
    get_window().title = "Godot Defender Clone    [milestone 3, %d FPS]" % [Performance.get_monitor(Performance.TIME_FPS)]


func _on_player_player_killed():
    get_tree().reload_current_scene()


func _on_update_window_title_timer_timeout():
    update_window_title()
