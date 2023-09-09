class_name MainLevel extends Node


func _on_player_player_killed():
    # show game over text, wait for a moment and then finish the game
    $UI/GameOverLabel.visible = true
    await get_tree().create_timer(1.5).timeout
    Events.game_finished.emit($UI/ScoreCounter.score)
