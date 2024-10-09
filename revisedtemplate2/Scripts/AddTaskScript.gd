extends Node2D


var task_type = ""  
var goal_type = ""  
var task_name = ""
var task_description = ""
var is_repeatable = false
var has_deadline = false
var repeat_frequency = ""
var time = ""


func _ready():
	
	$OptionButton.connect("item_selected", Callable(self, "_on_task_type_selected"))
	$Button.connect("pressed", Callable(self, "_on_sign_contract_pressed"))
	$BackButton.connect("pressed", Callable(self, "_on_back_button_pressed"))


func _on_task_type_selected(index: int):
	if index == 0:  
		task_type = "Task"
		$OptionButton3.disabled = true  
		$CheckBox.disabled = false  
		$CheckBox2.disabled = false  
		$OptionButton2.disabled = false  
	else:  
		task_type = "Goal"
		$OptionButton3.disabled = false  
		$CheckBox.disabled = true  
		$CheckBox.button_pressed = false  
		$CheckBox2.disabled = true  
		$CheckBox2.button_pressed = true  
		$OptionButton2.disabled = true  


func _on_sign_contract_pressed():
	
	task_name = $TextEdit.text
	task_description = $TextEdit2.text
	is_repeatable = $CheckBox.button_pressed
	has_deadline = $CheckBox2.button_pressed
	repeat_frequency = $OptionButton2.text
	time = $LineEdit.text

	
	if task_type == "Goal":
		goal_type = $OptionButton3.text  

	
	var new_contract = {
		"task_type": task_type,  
		"goal_type": goal_type if task_type == "Goal" else null,  
		"name": task_name,
		"description": task_description,
		"repeatable": is_repeatable if task_type == "Task" else false,  
		"deadline": has_deadline,
		"frequency": repeat_frequency if task_type == "Task" else null,  
		"time": time
	}

	
	GlobalScript.contracts.append(new_contract)

	
	print("New contract created: ", new_contract)

	
	get_tree().change_scene_to_file("res://Scenes/MainListScene.tscn")


func _on_back_button_pressed():
	
	get_tree().change_scene_to_file("res://Scenes/MainListScene.tscn")
