extends Area2D

const speed: float = 1000
var direction := Vector2.RIGHT


func setup(spawn_position: Vector2, orientation: float):
    global_position = spawn_position
    direction = direction * orientation
    scale.x = orientation


func _physics_process(delta):
    position += direction * speed * delta


func _on_area_entered(_area):
    queue_free()
