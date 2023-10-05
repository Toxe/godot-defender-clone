extends Control

@export var main_level: MainLevel = null


func _ready():
    if OS.has_feature("debug"):
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
    if main_level && main_level._world:
        main_level._world.get_node("SpawnWaves/WaveTimer").start(0.2)


func toggle_visibility():
    visible = !visible
    if visible:
        update_ui()
    start_or_stop_ui_update_timer()


func start_or_stop_ui_update_timer():
    if visible:
        $UIUpdateTimer.start()
    else:
        $UIUpdateTimer.stop()


func update_ui():
    if main_level && main_level._world:
        var spawn_waves = main_level._world.get_node("SpawnWaves") as SpawnWaves
        if spawn_waves:
            %LevelNumberLabel.text = "Level %d" % main_level._world.level_number
            %SpawnWavesLabel.text = "Spawn waves left: %d, time until next wave: %.01f" % [spawn_waves._spawn_waves_left, spawn_waves.get_node("WaveTimer").time_left]
            if spawn_waves._spawning_new_wave:
                %SpawnWavesLabel.text += " [spawning new wave]"


func _on_ui_update_timer_timeout():
    update_ui()
