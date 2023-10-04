class_name SpawnWaves extends Node

const number_of_spawn_waves := 3
const time_to_immediate_wave := 1
const time_to_next_wave := 30

@onready var _spawn_waves_left = number_of_spawn_waves
var _spawning_new_wave := false


func _ready():
    Events.enemy_destroyed.connect(_on_enemy_destroyed)


func start_timer_to_spawn_immediate_wave():
    if not _spawning_new_wave:
        _spawning_new_wave = true
        $Timer.start(time_to_immediate_wave)


func start_timer_to_next_wave():
    $Timer.start(time_to_next_wave)


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
            start_timer_to_next_wave()
        else:
            stop()


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
    if has_waves_left() && is_spawn_wave_completed(Enemy.collect_existing_enemies(get_tree())):
        start_timer_to_spawn_immediate_wave()
