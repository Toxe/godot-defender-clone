extends Node

const main_level_scene = preload("res://scenes/levels/main/main.tscn")
const title_scene = preload("res://scenes/levels/title/title.tscn")


func _ready() -> void:
    Events.start_game.connect(_on_start_game)
    Events.game_finished.connect(_on_game_finished)

    create_window_title_update_timer()
    update_window_title()

    # wait for the main scene to become ready
    await get_tree().process_frame

    # if the main scene is the title scene then we make sure to show the title screen
    var title := get_tree().current_scene as TitleScene
    if title:
        title.show_title_screen()


func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("quit"):
        get_tree().quit()


func create_window_title_update_timer() -> void:
    var timer := Timer.new()
    add_child(timer)
    timer.timeout.connect(update_window_title)
    timer.start(1.0)


func update_window_title() -> void:
    get_window().title = "Godot Defender Clone    [milestone 7, %d FPS]" % [Performance.get_monitor(Performance.TIME_FPS)]


func load_scene(scene: PackedScene) -> void:
    get_tree().unload_current_scene()
    get_tree().change_scene_to_packed(scene)
    await get_tree().process_frame


func _on_start_game() -> void:
    await load_scene(main_level_scene)


func _on_game_finished(score: int) -> void:
    await load_scene(title_scene)

    var title := get_tree().current_scene as TitleScene
    title.update_high_score_data(score)
    title.show_high_score_or_title_screen()  # show either high score screen if score was added to high scores or title screen otherwise
