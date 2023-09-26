class_name World extends Node

const player_scene = preload("res://scenes/player/player.tscn")
const human_scene = preload("res://scenes/human/human.tscn")
const enemy_lander_scene = preload("res://scenes/enemies/lander.tscn")
const enemy_bomber_scene = preload("res://scenes/enemies/bomber.tscn")
const enemy_pod_scene = preload("res://scenes/enemies/pod.tscn")
const enemy_swarmer_scene = preload("res://scenes/enemies/swarmer.tscn")

const human_min_spawn_distance := 100.0
const enemies_min_spawn_distance := 300.0


func spawn_player() -> Player:
    # spawn player in the middle of the level
    var level_chunks = get_ordered_level_chunks()
    var spawn_rect := Rect2(level_chunks.front().global_position, Vector2(level_chunks.size() * 1152, 648))

    var player = player_scene.instantiate() as Player
    player.global_position = spawn_rect.get_center()

    add_child(player)
    return player


func spawn_entities(count: int, entity_scene: PackedScene, spawn_rect: Rect2, min_spawn_distance: float, other_entities: Array[Node2D] = []) -> Array[Node2D]:
    var spawned_entities: Array[Node2D] = []

    while spawned_entities.size() < count:
        # pick a random spawn position that isn't too close to other entities
        var position := random_spawn_position(spawn_rect)
        while position_is_too_close(position, spawned_entities, min_spawn_distance) || position_is_too_close(position, other_entities, min_spawn_distance):
            position = random_spawn_position(spawn_rect)

        var entity = entity_scene.instantiate() as Node2D
        entity.global_position = position

        var entity_movement_component = entity.get_node("MovementComponent") as MovementComponent
        if entity_movement_component:
            entity_movement_component.direction = random_direction()

        spawned_entities.append(entity)
        add_child(entity)

    return spawned_entities


func spawn_humans(count: int):
    spawn_entities(count, human_scene, calc_spawn_rect($Spawns/HumanSpawnPath/SpawnLocation, human_min_spawn_distance), human_min_spawn_distance)


func spawn_enemy_wave(num_landers: int, num_bombers: int, num_random_enemies: int, player: Player):
    var lander_spawn_rect := calc_spawn_rect($Spawns/LanderSpawnPath/SpawnLocation, enemies_min_spawn_distance)
    var normal_enemy_spawn_rect := calc_spawn_rect($Spawns/NormalEnemySpawnPath/SpawnLocation, enemies_min_spawn_distance)

    var all_entities: Array[Node2D] = [player]  # avoid the player

    all_entities.append_array(spawn_entities(num_landers, enemy_lander_scene, lander_spawn_rect, enemies_min_spawn_distance, all_entities))
    all_entities.append_array(spawn_entities(num_bombers, enemy_bomber_scene, normal_enemy_spawn_rect, enemies_min_spawn_distance, all_entities))

    var random_enemy_scenes = [enemy_bomber_scene, enemy_pod_scene, enemy_swarmer_scene]
    for i in num_random_enemies:
        all_entities.append_array(spawn_entities(1, random_enemy_scenes.pick_random(), normal_enemy_spawn_rect, enemies_min_spawn_distance, all_entities))


func random_direction() -> Vector2:
    return [Vector2.LEFT, Vector2.RIGHT].pick_random()


func random_spawn_position(spawn_rect: Rect2) -> Vector2:
    return Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x),
                   randf_range(spawn_rect.position.y, spawn_rect.end.y))


func position_is_too_close(position: Vector2, nodes: Array[Node2D], min_distance: float) -> bool:
    return nodes.any(func(other: Node2D): return position.distance_to(other.global_position) < min_distance)


func calc_spawn_rect(spawn_location: PathFollow2D, right_margin: float) -> Rect2:
    # get the left-most level chunk
    var level_chunks = get_ordered_level_chunks()
    var left_level_chunk = level_chunks.front() as LevelChunk

    # top and bottom coordinates
    var top := point_on_path(spawn_location, 0.0)
    var bottom := point_on_path(spawn_location, 1.0)
    assert(top <= bottom)

    return Rect2(left_level_chunk.global_position.x, top, level_chunks.size() * 1152 - right_margin, bottom - top)


func point_on_path(path_follow: PathFollow2D, progress_ratio: float) -> float:
    path_follow.progress_ratio = progress_ratio
    return path_follow.global_position.y


func get_ordered_level_chunks() -> Array[Node]:
    var level_chunks = $LevelChunks.get_children()
    level_chunks.sort_custom(func(a: LevelChunk, b: LevelChunk): return a.global_position.x < b.global_position.x)
    return level_chunks
