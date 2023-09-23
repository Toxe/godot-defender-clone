class_name World extends Node

const player_scene = preload("res://scenes/player/player.tscn")
const human_scene = preload("res://scenes/human/human.tscn")

const human_min_spawn_distance := 100.0


func _ready():
    for chunk in get_ordered_level_chunks():
        chunk.level_chunk_exited.connect(_on_level_chunk_exited)


func spawn_player():
    var player = player_scene.instantiate() as Player
    player.global_position = $PlayerSpawnPoint.global_position
    add_child(player)


func spawn_humans(count: int):
    var spawned_humans: Array[Human] = []
    var spawn_rect := human_spawn_rect(human_min_spawn_distance)

    while spawned_humans.size() < count:
        # pick a random spawn position that isn't too close to other humans
        var position := random_spawn_position(spawn_rect)
        while position_is_too_close(position, spawned_humans, human_min_spawn_distance):
            position = random_spawn_position(spawn_rect)

        var human = human_scene.instantiate() as Human
        var human_movement_component = human.get_node("MovementComponent") as MovementComponent
        human.global_position = position
        human_movement_component.direction = random_direction()

        spawned_humans.append(human)
        add_child(human)


func random_direction() -> Vector2:
    return [Vector2.LEFT, Vector2.RIGHT].pick_random()


func random_spawn_position(spawn_rect: Rect2) -> Vector2:
    return Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x),
                   randf_range(spawn_rect.position.y, spawn_rect.end.y))


func position_is_too_close(position: Vector2, nodes: Array[Human], min_distance: float) -> bool:
    return nodes.any(func(human: Human): return absf(position.x - human.position.x) < min_distance)


func human_spawn_rect(right_margin: float = 0.0) -> Rect2:
    # get the left-most level chunk
    var level_chunks = get_ordered_level_chunks()
    var left_level_chunk = level_chunks.front() as LevelChunk

    # top and bottom coordinates
    $HumanSpawnPath/SpawnLocation.progress_ratio = 0.0
    var top: float = $HumanSpawnPath/SpawnLocation.global_position.y

    $HumanSpawnPath/SpawnLocation.progress_ratio = 1.0
    var bottom: float = $HumanSpawnPath/SpawnLocation.global_position.y

    assert(top <= bottom)
    return Rect2(left_level_chunk.global_position.x, top, level_chunks.size() * 1152 - right_margin, bottom - top)


func get_ordered_level_chunks() -> Array[Node]:
    var level_chunks = $LevelChunks.get_children()
    level_chunks.sort_custom(func(a: LevelChunk, b: LevelChunk): return a.global_position.x < b.global_position.x)
    return level_chunks


func _on_level_chunk_exited(level_chunk: LevelChunk, node: Node2D):
    var level_chunks = get_ordered_level_chunks()
    var first_level_chunk = level_chunks.front() as LevelChunk
    var last_level_chunk = level_chunks.back() as LevelChunk

    if node is Player:
        if node.global_position.x < level_chunk.global_position.x:
            last_level_chunk.global_position.x -= level_chunks.size() * 1152
        elif node.global_position.x > level_chunk.global_position.x + 1152:
            first_level_chunk.global_position.x += level_chunks.size() * 1152
    else:
        if node.global_position.x < first_level_chunk.global_position.x:
            node.global_position.x += level_chunks.size() * 1152
        elif node.global_position.x > last_level_chunk.global_position.x + 1152:
            node.global_position.x -= level_chunks.size() * 1152
