class_name MainLevel extends Node

const human_scene = preload("res://scenes/human/human.tscn")

const human_min_spawn_distance := 100.0


func _ready():
    spawn_humans(8)


func spawn_humans(count: int):
    var spawn_rect := human_spawn_rect(human_min_spawn_distance)
    var spawned_humans: Array[Node2D] = []

    while spawned_humans.size() < count:
        var human = human_scene.instantiate() as Node2D
        var human_movement_component = human.get_node("MovementComponent") as MovementComponent
        human_movement_component.direction = random_direction()

        # pick a random spawn position that isn't too close to other humans
        human.global_position = random_spawn_position(spawn_rect)
        while position_is_too_close(human.global_position, spawned_humans, human_min_spawn_distance):
            human.global_position = random_spawn_position(spawn_rect)

        spawned_humans.append(human)
        add_child(human)


func random_direction() -> Vector2:
    return [Vector2.LEFT, Vector2.RIGHT].pick_random()


func random_spawn_position(spawn_rect: Rect2) -> Vector2:
    var spawn_position := Vector2()
    spawn_position.x = randf_range(spawn_rect.position.x, spawn_rect.end.x)
    spawn_position.y = randf_range(spawn_rect.position.y, spawn_rect.end.y)
    return spawn_position


func position_is_too_close(position: Vector2, nodes: Array[Node2D], min_distance: float) -> bool:
    return nodes.any(func(node: Node2D): return absf(position.x - node.global_position.x) < min_distance)


func human_spawn_rect(right_margin: float = 0.0) -> Rect2:
    # find the coordinate of the left-most level chunk
    var positions: Array[float] = []
    for child in $LevelChunks.get_children():
        var chunk = child as Area2D
        positions.append(chunk.global_position.x)
    var left: float = positions.min()

    # top and bottom coordinate
    $HumanSpawnPath/SpawnLocation.progress_ratio = 0.0
    var top: float = $HumanSpawnPath/SpawnLocation.global_position.y

    $HumanSpawnPath/SpawnLocation.progress_ratio = 1.0
    var bottom: float = $HumanSpawnPath/SpawnLocation.global_position.y

    assert(top <= bottom)
    return Rect2(left, top, 3.0 * 1152.0 - right_margin, bottom - top)


func _on_player_player_killed():
    # show game over text, wait for a moment and then finish the game
    $UI/GameOverLabel.visible = true
    await get_tree().create_timer(1.5).timeout
    Events.game_finished.emit($ScoreCounter.score)
