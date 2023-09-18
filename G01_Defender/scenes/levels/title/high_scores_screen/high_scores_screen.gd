class_name HighScoresScreen extends Control

var _current_high_score_data: HighScoreManagerComponent.HighScoreData = null


func update_high_score_screen(high_score_data: HighScoreManagerComponent.HighScoreData):
    if _current_high_score_data == high_score_data:
        return

    _current_high_score_data = high_score_data

    if not high_score_data or high_score_data.high_scores.is_empty():
        $NoHighScoresLabel.visible = true
        $ScoreLabelsContainer.visible = false
        $NewHighestScoreLabel.visible = false
    else:
        $NoHighScoresLabel.visible = false
        $ScoreLabelsContainer.visible = true
        $NewHighestScoreLabel.visible = high_score_data.was_highest_score

        var label_highlighted := false

        for label_score in high_score_data.high_scores:
            var label = Label.new()
            label.text = str(label_score)
            label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

            # highlight the first label that shows the score of the previous game
            if not label_highlighted and label_score == high_score_data.latest_score:
                label.theme_type_variation = "HighlightedLabel"
                label_highlighted = true

            $ScoreLabelsContainer.add_child(label)
