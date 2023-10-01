class_name World extends Node

@onready var spawns = $Spawns as Spawns


func _ready():
    Events.spawn_new_wave.connect(_on_spawn_new_wave)

    var level_chunks := get_ordered_level_chunks()
    spawns.spawn_player(level_chunks)
    spawns.spawn_humans(8, level_chunks)


func get_ordered_level_chunks() -> Array[LevelChunk]:
    var level_chunks: Array[LevelChunk] = []
    for node in $LevelChunks.get_children():
        if node is LevelChunk:
            level_chunks.append(node)

    level_chunks.sort_custom(func(a: LevelChunk, b: LevelChunk): return a.global_position.x < b.global_position.x)
    return level_chunks


func _on_spawn_new_wave():
    spawns.spawn_enemy_wave(6, 2, 2, get_ordered_level_chunks())
