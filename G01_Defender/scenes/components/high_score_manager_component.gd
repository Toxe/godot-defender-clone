class_name HighScoreManagerComponent extends Node

class HighScoreData:
    var latest_score := 0
    var was_added_to_high_scores := false
    var was_highest_score := false
    var high_scores := []

    func _init(score: int):
        latest_score = score


@export var filename = "user://high_scores.json"
@export var max_number_of_high_scores = 10

var high_scores := []


func _ready():
    load_high_scores()


func get_high_score_data() -> HighScoreData:
    var high_score_data = HighScoreData.new(0)
    high_score_data.high_scores = high_scores.duplicate()
    return high_score_data


func add_if_valid_high_score(score: int) -> HighScoreData:
    var high_score_data = HighScoreData.new(score)
    if score > 0:
        if could_be_added_to_high_scores(score):
            high_score_data.was_highest_score = would_be_new_highest_score(score)
            high_score_data.was_added_to_high_scores = true
            high_scores.append(score)
    sort_and_resize()
    save_high_scores()
    high_score_data.high_scores = high_scores.duplicate()
    return high_score_data


func load_high_scores():
    if FileAccess.file_exists(filename):
        var file = FileAccess.open(filename, FileAccess.READ)
        if file:
            high_scores = JSON.parse_string(file.get_as_text())
            sort_and_resize()
        else:
            push_warning("unable to load file ", filename)


func save_high_scores():
    var file = FileAccess.open(filename, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(high_scores, "  "))
    else:
        push_warning("unable to save file ", filename)


func is_full() -> bool:
    return high_scores.size() >= max_number_of_high_scores


func sort_and_resize():
    high_scores.sort()
    high_scores.reverse()
    if is_full():
        high_scores.resize(max_number_of_high_scores)


func could_be_added_to_high_scores(score: int) -> bool:
    if not is_full():
        return true
    return high_scores.any(func(n) -> bool: return n < score)


func would_be_new_highest_score(score: int) -> bool:
    if high_scores.is_empty():
        return true
    return score > high_scores.max()
