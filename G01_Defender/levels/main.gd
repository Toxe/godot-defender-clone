extends Node


func _on_player_player_killed():
    get_tree().reload_current_scene()
