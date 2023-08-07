extends Area2D

const speed: float = 50
var direction := Vector2(-1, 0.3).normalized()


func _physics_process(delta):
    position += direction * speed * delta


func _on_area_entered(_area):
    queue_free()
