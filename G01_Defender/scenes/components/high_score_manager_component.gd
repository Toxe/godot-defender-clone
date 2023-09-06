class_name HighScoreManagerComponent extends Node

@export var filename = "user://high_scores.json"
@export var max_number_of_high_scores = 10

var _high_scores := []


func _ready():
    load_high_scores()


func load_high_scores():
    if FileAccess.file_exists(filename):
        var file = FileAccess.open(filename, FileAccess.READ)
        if file:
            _high_scores = JSON.parse_string(file.get_as_text())
            sort_and_resize()
        else:
            push_warning("unable to load file ", filename)


func save_high_scores():
    var file = FileAccess.open(filename, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(_high_scores, "  "))
    else:
        push_warning("unable to save file ", filename)


func is_full() -> bool:
    return _high_scores.size() >= max_number_of_high_scores


func sort_and_resize():
    _high_scores.sort()
    _high_scores.reverse()
    if is_full():
        _high_scores.resize(max_number_of_high_scores)


func add(score: int):
    _high_scores.append(score)
    sort_and_resize()
    save_high_scores()


func could_be_added_to_high_scores(score: int) -> bool:
    if not is_full():
        return true
    return _high_scores.any(func(n) -> bool: return n < score)


func would_be_new_highest_score(score: int) -> bool:
    if _high_scores.is_empty():
        return true
    return score > _high_scores.max()
