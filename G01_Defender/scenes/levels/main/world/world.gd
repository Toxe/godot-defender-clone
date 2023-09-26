class_name World extends Node

@onready var spawns = $Spawns as Spawns


func _ready():
    var level_chunks := get_ordered_level_chunks()
    var player := spawns.spawn_player(level_chunks)
    spawns.spawn_humans(8, level_chunks)
    spawns.spawn_enemy_wave(6, 2, 2, player, level_chunks)


func get_ordered_level_chunks() -> Array[Node]:
    var level_chunks = $LevelChunks.get_children()
    level_chunks.sort_custom(func(a: LevelChunk, b: LevelChunk): return a.global_position.x < b.global_position.x)
    return level_chunks
