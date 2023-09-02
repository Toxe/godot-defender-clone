class_name MainLevel extends Node

signal game_finished


func _on_player_player_killed():
    game_finished.emit()
