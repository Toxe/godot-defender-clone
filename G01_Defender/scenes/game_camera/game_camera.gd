class_name GameCamera extends Node2D


func center_camera():
    $Camera2D.position.x = 0


# wrap around to the other side of the level
func wrap_around_level(node: Node2D):
    if node.global_position.x < global_position.x:
        node.position.x += 3*1152
    else:
        node.position.x -= 3*1152


func _on_wrap_enemies_area_exited(area: Area2D):
    wrap_around_level(area.get_parent())


func _on_wrap_level_chunks_area_exited(area: Area2D):
    wrap_around_level(area)
