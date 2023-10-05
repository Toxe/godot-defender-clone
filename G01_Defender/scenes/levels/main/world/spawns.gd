class_name Spawns extends Node2D

const player_scene = preload("res://scenes/player/player.tscn")
const human_scene = preload("res://scenes/human/human.tscn")
const enemy_baiter_scene = preload("res://scenes/enemies/baiter.tscn")
const enemy_bomber_scene = preload("res://scenes/enemies/bomber.tscn")
const enemy_lander_scene = preload("res://scenes/enemies/lander.tscn")
const enemy_pod_scene = preload("res://scenes/enemies/pod.tscn")
const enemy_swarmer_scene = preload("res://scenes/enemies/swarmer.tscn")

const human_min_spawn_distance := 100.0
const enemies_min_spawn_distance := 300.0


func spawn_player(ordered_level_chunks: Array[LevelChunk]) -> Player:
    # spawn player in the center of the level
    var player = player_scene.instantiate() as Player
    player.global_position = calc_level_rect(ordered_level_chunks).get_center()
    add_child(player)
    return player


func spawn_entities(count: int, entity_scene: PackedScene, spawn_rect: Rect2, min_spawn_distance: float, other_entities: Array[Node2D] = []) -> Array[Node2D]:
    var spawned_entities: Array[Node2D] = []

    while spawned_entities.size() < count:
        var random_spawn := random_spawn_position(spawn_rect, min_spawn_distance, spawned_entities, other_entities)
        min_spawn_distance = random_spawn.min_spawn_distance

        var entity = entity_scene.instantiate() as Node2D
        entity.global_position = random_spawn.position

        var entity_movement_component = entity.get_node("MovementComponent") as MovementComponent
        if entity_movement_component:
            entity_movement_component.direction = random_direction()

        spawned_entities.append(entity)
        add_child(entity)

    return spawned_entities


func spawn_humans(count: int, ordered_level_chunks: Array[LevelChunk]):
    spawn_entities(count, human_scene, calc_spawn_rect($HumanSpawnPath/SpawnLocation, human_min_spawn_distance, ordered_level_chunks), human_min_spawn_distance)


func spawn_baiter(ordered_level_chunks: Array[LevelChunk]):
    spawn_entities(1, enemy_baiter_scene, calc_spawn_rect($NormalEnemySpawnPath/SpawnLocation, enemies_min_spawn_distance, ordered_level_chunks), enemies_min_spawn_distance)


func spawn_enemy_wave(num_landers: int, num_bombers: int, num_random_enemies: int, ordered_level_chunks: Array[LevelChunk]):
    var lander_spawn_rect := calc_spawn_rect($LanderSpawnPath/SpawnLocation, enemies_min_spawn_distance, ordered_level_chunks)
    var normal_enemy_spawn_rect := calc_spawn_rect($NormalEnemySpawnPath/SpawnLocation, enemies_min_spawn_distance, ordered_level_chunks)

    var all_entities := collect_existing_enemies_and_player()

    all_entities.append_array(spawn_entities(num_landers, enemy_lander_scene, lander_spawn_rect, enemies_min_spawn_distance, all_entities))
    all_entities.append_array(spawn_entities(num_bombers, enemy_bomber_scene, normal_enemy_spawn_rect, enemies_min_spawn_distance, all_entities))

    var random_enemy_scenes = [enemy_bomber_scene, enemy_pod_scene, enemy_swarmer_scene]
    for i in num_random_enemies:
        all_entities.append_array(spawn_entities(1, random_enemy_scenes.pick_random(), normal_enemy_spawn_rect, enemies_min_spawn_distance, all_entities))


func random_direction() -> Vector2:
    return [Vector2.LEFT, Vector2.RIGHT].pick_random()


func random_position_in_rect(spawn_rect: Rect2) -> Vector2:
    return Vector2(randf_range(spawn_rect.position.x, spawn_rect.end.x),
                   randf_range(spawn_rect.position.y, spawn_rect.end.y))


class RandomSpawnPosition:
    var position: Vector2
    var min_spawn_distance: float
    func _init(pos: Vector2, dist: float):
        position = pos
        min_spawn_distance = dist


# pick a random spawn position that isn't too close to other entities and if it takes too many tries cut the minimum distance in half
func random_spawn_position(spawn_rect: Rect2, min_spawn_distance: float, spawned_entities: Array[Node2D], other_entities: Array[Node2D]) -> RandomSpawnPosition:
    var repeats = 0
    var random_spawn = RandomSpawnPosition.new(random_position_in_rect(spawn_rect), min_spawn_distance)

    while position_is_too_close(random_spawn, spawned_entities) || position_is_too_close(random_spawn, other_entities):
        random_spawn.position = random_position_in_rect(spawn_rect)
        repeats += 1
        if repeats >= 10:
            random_spawn.min_spawn_distance /= 2.0
            repeats = 0

    return random_spawn


func position_is_too_close(random_spawn: RandomSpawnPosition, nodes: Array[Node2D]) -> bool:
    return nodes.any(func(other: Node2D): return random_spawn.position.distance_to(other.global_position) < random_spawn.min_spawn_distance)


func calc_spawn_rect(spawn_location: PathFollow2D, right_margin: float, ordered_level_chunks: Array[LevelChunk]) -> Rect2:
    # top and bottom coordinates
    var top := point_on_path(spawn_location, 0.0)
    var bottom := point_on_path(spawn_location, 1.0)
    assert(top <= bottom)

    var level_rect := calc_level_rect(ordered_level_chunks)
    return Rect2(level_rect.position.x, top, level_rect.size.x - right_margin, bottom - top)


func calc_level_rect(ordered_level_chunks: Array[LevelChunk]) -> Rect2:
    return Rect2(ordered_level_chunks.front().global_position, Vector2(ordered_level_chunks.size() * 1152, 648))


func point_on_path(path_follow: PathFollow2D, progress_ratio: float) -> float:
    path_follow.progress_ratio = progress_ratio
    return path_follow.global_position.y


func collect_existing_enemies_and_player() -> Array[Node2D]:
    var nodes: Array[Node2D] = []

    var player = get_tree().get_first_node_in_group("player") as Player
    if player && not player.is_queued_for_deletion():
        nodes.append(player)

    nodes.append_array(Enemy.collect_existing_enemies(get_tree()))
    return nodes
