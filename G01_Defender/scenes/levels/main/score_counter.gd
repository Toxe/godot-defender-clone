extends Node

@export var score_label: Label = null

var score = 0


func _ready():
    Events.enemy_destroyed.connect(_on_enemy_destroyed)
    update_label()


func update_label():
    if score_label:
        score_label.text = "Score: " + str(score)


func _on_enemy_destroyed(enemy: Enemy):
    score += enemy.score
    update_label()
