extends Node

@export var lives_label: Label = null

var _lives = 2


func _ready():
    update_label()


func has_lives_left() -> bool:
    return _lives > 0


func decrease():
    assert(has_lives_left())
    _lives -= 1
    update_label()


func update_label():
    if lives_label:
        lives_label.text = "Lives: " + str(_lives)
