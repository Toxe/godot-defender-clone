extends Area2D


func setup(spawn_position: Vector2):
    global_position = spawn_position


func _on_area_entered(_area):
    queue_free()
