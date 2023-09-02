class_name Game extends Node

const main_level_scene = preload("res://scenes/levels/main/main.tscn")
const title_level_scene = preload("res://scenes/levels/title/title.tscn")

var current_level: Node = null


func _ready():
    update_window_title()
    load_title_scene()


func load_title_scene():
    var title = load_level(title_level_scene) as TitleScene
    title.start_game.connect(_on_start_game)


func load_main_level():
    var main_level = load_level(main_level_scene) as MainLevel
    main_level.game_finished.connect(_on_game_finished)


func load_level(scene: Resource) -> Node:
    if is_instance_valid(current_level):
        current_level.queue_free()
    current_level = scene.instantiate()
    add_child(current_level)
    return current_level


func update_window_title():
    get_window().title = "Godot Defender Clone    [milestone 4, %d FPS]" % [Performance.get_monitor(Performance.TIME_FPS)]


func _on_start_game():
    load_main_level()


func _on_game_finished():
    load_title_scene()


func _on_update_window_title_timer_timeout():
    update_window_title()
