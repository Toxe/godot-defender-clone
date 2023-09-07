extends Label

var score := 0


func _ready():
    Events.enemy_destroyed.connect(_on_enemy_destroyed)


func _on_enemy_destroyed(enemy: Enemy):
    score += enemy.score
    text = "Score: %d" % score
