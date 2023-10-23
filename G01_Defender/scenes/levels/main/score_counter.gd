extends Node

@export var score_label: Label = null

var score := 0

var _score_until_next_extra_life := 10000


func _ready() -> void:
    Events.enemy_destroyed.connect(_on_enemy_destroyed)
    update_label()


func update_label() -> void:
    if score_label:
        score_label.text = "Score: " + str(score)


func _on_enemy_destroyed(enemy: Enemy) -> void:
    score += enemy.score
    update_label()

    _score_until_next_extra_life -= enemy.score
    if _score_until_next_extra_life <= 0:
        _score_until_next_extra_life += 10000
        Events.extra_life.emit()
