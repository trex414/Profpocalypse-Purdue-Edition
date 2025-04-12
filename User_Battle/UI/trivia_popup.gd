extends Control

signal answer_chosen(correct: bool)

var correct_answer = ""

func setup_question(question: String, answers: Array, correct: String):
	print("❓ Trivia question shown")
	$Panel/VBoxContainer/QuestionLabel.text = question
	correct_answer = correct
	
	var buttons = [
		$Panel/VBoxContainer/AnswerA,
		$Panel/VBoxContainer/AnswerB,
		$Panel/VBoxContainer/AnswerC
	]
	
	for i in range(buttons.size()):
		buttons[i].text = answers[i]
		buttons[i].connect("pressed", Callable(self, "_on_answer_pressed").bind(answers[i]))


func _on_answer_pressed(selected_answer: String):
	var is_correct = selected_answer == correct_answer
	emit_signal("answer_chosen", is_correct)
	queue_free()  # close the popup after answering
