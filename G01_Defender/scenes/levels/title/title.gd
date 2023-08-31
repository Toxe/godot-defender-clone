extends Node

@onready var screens = [$TitleScreen, $HighScoresScreen, $EnemiesScreen]
var current_screen_index := 0


func switch_to_next_screen():
    var current_screen = screens[current_screen_index]
    current_screen_index = (current_screen_index + 1) % screens.size()
    var next_screen = screens[current_screen_index]

    current_screen.visible = false
    next_screen.visible = true


func _on_switch_screen_timer_timeout():
    switch_to_next_screen()
