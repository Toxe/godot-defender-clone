extends Node

@export var lives_label: Label = null

var _lives = 2


func _ready():
    Events.extra_life.connect(_on_extra_life)
    update_label()


func has_lives_left() -> bool:
    return _lives > 0


func increase():
    _lives += 1
    update_label()


func decrease():
    assert(has_lives_left())
    _lives -= 1
    update_label()


func update_label():
    if lives_label:
        lives_label.text = "Lives: " + str(_lives)


func _on_extra_life():
    increase()
