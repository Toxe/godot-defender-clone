class_name SpawnWaves extends Node

signal spawn_baiter
signal spawn_new_wave

const number_of_spawn_waves := 3
const time_to_immediate_wave := 1
const time_to_next_wave := 30

var _spawn_waves_left := number_of_spawn_waves
var _spawning_new_wave := false
var _is_level_completed := false


func _ready() -> void:
    Events.enemy_destroyed.connect(_on_enemy_destroyed)


func start_timer_to_spawn_wave_immediately() -> void:
    if not _spawning_new_wave:
        _spawning_new_wave = true
        $WaveTimer.start(time_to_immediate_wave)


func has_waves_left() -> bool:
    return _spawn_waves_left > 0


func is_spawn_wave_completed(enemies: Array[Enemy]) -> bool:
    if enemies.is_empty():
        return true
    return not contains_landers_and_mutants(enemies)


func contains_landers_and_mutants(enemies: Array[Enemy]) -> bool:
    return enemies.any(func(enemy: Enemy) -> bool: return enemy.type == Enums.EnemyType.Lander || enemy.type == Enums.EnemyType.Mutant)


func level_completed() -> void:
    if not _is_level_completed:
        _is_level_completed = true
        Events.level_completed.emit()


func _on_enemy_destroyed(_enemy: Enemy) -> void:
    if is_spawn_wave_completed(Enemy.collect_existing_enemies(get_tree())):
        if has_waves_left():
            start_timer_to_spawn_wave_immediately()
        else:
            level_completed()


func _on_baiter_timer_timeout() -> void:
    spawn_baiter.emit()


func _on_wave_timer_timeout() -> void:
    if has_waves_left():
        _spawn_waves_left -= 1
        _spawning_new_wave = false

        if has_waves_left():
            $WaveTimer.start(time_to_next_wave)
        else:
            $WaveTimer.stop()

        spawn_new_wave.emit()
    else:
        $WaveTimer.stop()
