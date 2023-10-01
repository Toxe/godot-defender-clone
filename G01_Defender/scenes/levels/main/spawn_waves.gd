extends Node

const number_of_spawn_waves := 3
const time_to_first_spawn_wave := 1
const time_to_next_spawn_wave := 30

@onready var _spawn_waves_left = number_of_spawn_waves
var _spawning_new_wave := false


func _ready():
    Events.enemy_destroyed.connect(_on_enemy_destroyed)


func start():
    if not _spawning_new_wave:
        _spawning_new_wave = true
        $Timer.start(time_to_first_spawn_wave)


func restart():
    $Timer.start(time_to_next_spawn_wave)


func stop():
    $Timer.stop()


func has_waves_left() -> bool:
    return _spawn_waves_left > 0


func spawn_new_wave():
    if has_waves_left():
        _spawn_waves_left -= 1
        _spawning_new_wave = false
        Events.spawn_new_wave.emit()

        if has_waves_left():
            restart()
        else:
            stop()


func collect_existing_enemies() -> Array[Enemy]:
    var enemies: Array[Enemy] = []
    for enemy in get_tree().get_nodes_in_group("enemies"):
        if not enemy.is_queued_for_deletion():
            enemies.append(enemy)
    return enemies


func is_spawn_wave_completed(enemies: Array[Enemy]) -> bool:
    if enemies.is_empty():
        return true
    return not contains_landers_and_mutants(enemies)


func contains_landers_and_mutants(enemies) -> bool:
    return enemies.any(func(enemy: Enemy): return enemy.type == Enums.EnemyType.Lander || enemy.type == Enums.EnemyType.Mutant)


func _on_timer_timeout():
    if has_waves_left():
        spawn_new_wave()
    else:
        stop()


func _on_enemy_destroyed(_enemy: Enemy):
    if has_waves_left() && is_spawn_wave_completed(collect_existing_enemies()):
        start()
