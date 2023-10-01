extends Control

@export var main_level: MainLevel = null

var _spawn_waves_component: SpawnWaves = null


func _ready():
    if OS.has_feature("debug"):
        if main_level:
            _spawn_waves_component = main_level.get_node("SpawnWaves")
        start_or_stop_ui_update_timer()


func _unhandled_key_input(event: InputEvent):
    if OS.has_feature("debug"):
        if event is InputEventKey and event.is_pressed() and not event.is_echo():
            match (event.keycode):
                KEY_C: toggle_visibility()
                KEY_P: debug_kill_player()
                KEY_K: debug_kill_all_enemies()
                KEY_L: debug_kill_landers_and_mutants()
                KEY_N: debug_spawn_new_wave()


func debug_kill_player():
    get_tree().get_first_node_in_group("player").get_node("HitboxComponent")._on_area_entered(null)


func debug_kill_all_enemies():
    for enemy in Enemy.collect_existing_enemies(get_tree()):
        enemy.get_node("HitboxComponent")._on_area_entered(null)


func debug_kill_landers_and_mutants():
    for enemy in Enemy.collect_existing_enemies(get_tree()):
        if enemy.type == Enums.EnemyType.Lander || enemy.type == Enums.EnemyType.Mutant:
            enemy.get_node("HitboxComponent")._on_area_entered(null)


func debug_spawn_new_wave():
    if _spawn_waves_component:
        _spawn_waves_component.get_node("Timer").start(0.2)


func toggle_visibility():
    visible = !visible
    start_or_stop_ui_update_timer()


func start_or_stop_ui_update_timer():
    if visible:
        $UIUpdateTimer.start()
    else:
        $UIUpdateTimer.stop()


func _on_ui_update_timer_timeout():
    if _spawn_waves_component:
        var s = "spawn waves left: %d, time until next wave: %.01f" % [_spawn_waves_component._spawn_waves_left, _spawn_waves_component.get_node("Timer").time_left]
        if _spawn_waves_component._spawning_new_wave:
            s += " [spawning new wave]"
        %SpawnWavesLabel.text = s
