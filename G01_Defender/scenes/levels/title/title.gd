class_name TitleScene extends Node

const _title_screen_index := 0
const _high_score_screen_index := 1
const _enemies_screen_index := 2

@onready var _screens: Array[Control] = [$TitleScreen, $HighScoresScreen, $EnemiesScreen]
var _current_screen_index := _title_screen_index

var _high_score_data: HighScoreManagerComponent.HighScoreData = null


func _ready():
    # get the high scores that the HighScoreManagerComponent has loaded at the start
    _high_score_data = $HighScoreManagerComponent.get_high_score_data()


func _unhandled_key_input(event: InputEvent):
    if event.is_action_pressed("quit"):
        pass  # let the game controller handle quit events
    else:
        if event.is_pressed() and not event.is_echo():
            get_viewport().set_input_as_handled()
            Events.start_game.emit()


func update_high_score_data(score: int):
    _high_score_data = $HighScoreManagerComponent.add_if_valid_high_score(score)


func show_high_score_or_title_screen():
    if _high_score_data.was_added_to_high_scores:
        show_high_score_screen()
    else:
        show_title_screen()


func show_title_screen():
    _switch_to_screen(_title_screen_index)


func show_high_score_screen():
    _switch_to_screen(_high_score_screen_index)


func _switch_to_screen(next_screen_index: int):
    assert(next_screen_index >= 0 && next_screen_index < _screens.size())

    # Update the high score screen controls only if we actually want to show the screen.
    # We don't need to create and arrange all those controls if we never actually switch to the high score screen.
    if next_screen_index == _high_score_screen_index:
        $HighScoresScreen.update_high_score_screen(_high_score_data)

    _screens[_current_screen_index].visible = false
    _screens[next_screen_index].visible = true
    _current_screen_index = next_screen_index

    $SwitchScreenTimer.start()


func _on_switch_screen_timer_timeout():
    _switch_to_screen((_current_screen_index + 1) % _screens.size())
