extends Node2D

const swarmer_scene = preload("swarmer.tscn")

const number_of_swarmers := 3
const swarmer_spawn_radius := 30.0
const swarmer_spawn_direction_rotation := 30.0


func swarmer_position() -> Vector2:
    return global_position + Vector2.from_angle(randf_range(0, 2*PI)) * swarmer_spawn_radius


func swarmer_direction() -> Vector2:
    var direction = Vector2.RIGHT if $MovementComponent.direction.x >= 0 else Vector2.LEFT
    return direction.rotated(deg_to_rad(randf_range(-swarmer_spawn_direction_rotation, swarmer_spawn_direction_rotation)))


# Pod destroyed, spawn a couple of Swarmers
func _on_hitbox_component_destroyed():
    for i in range(number_of_swarmers):
        var swarmer = swarmer_scene.instantiate()
        var swarmer_movement_component = swarmer.get_node("MovementComponent") as MovementComponent
        swarmer.global_position = swarmer_position()
        swarmer_movement_component.direction = swarmer_direction()
        get_parent().call_deferred("add_child", swarmer)
