class_name EnemyShootingAtPlayerStrategy extends Resource

@export var spread_angle := 0.0


# Note: shot is not yet in the tree so shot.global_position is still (0, 0) at this point and shot.get_tree() would return null
func update(scene_tree: SceneTree, shot: Node2D, shot_global_position: Vector2) -> void:
    if shot.has_node("MovementComponent"):
        var shot_movement_component := shot.get_node("MovementComponent") as MovementComponent
        var player := scene_tree.get_first_node_in_group("player") as Node2D
        if player:
            # shoot roughly into the direction of the player
            shot_movement_component.direction = (player.global_position - shot_global_position).rotated(deg_to_rad(randf_range(-spread_angle / 2.0, spread_angle / 2.0)))
        else:
            # no player found (could be dead), so just shoot into a random direction
            shot_movement_component.direction = Vector2.RIGHT.rotated(randf_range(0.0, 2.0 * PI))
