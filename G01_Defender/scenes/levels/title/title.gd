class_name TitleScene extends Node

signal start_game

@onready var screens = [$TitleScreen, $HighScoresScreen, $EnemiesScreen]
var current_screen_index := 0


func _unhandled_key_input(event: InputEvent):
    if event.is_action_pressed("quit"):
        pass  # let the game controller handle quit events
    else:
        if event.is_pressed() and not event.is_echo():
            start_game.emit()
            get_viewport().set_input_as_handled()


func switch_to_next_screen():
    var current_screen = screens[current_screen_index]
    current_screen_index = (current_screen_index + 1) % screens.size()
    var next_screen = screens[current_screen_index]

    current_screen.visible = false
    next_screen.visible = true


func _on_switch_screen_timer_timeout():
    switch_to_next_screen()
