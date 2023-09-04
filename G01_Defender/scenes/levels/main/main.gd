class_name MainLevel extends Node

signal game_finished


func _on_player_player_killed():
    $GameOverLayer.visible = true
    await get_tree().create_timer(1.5).timeout
    game_finished.emit()
