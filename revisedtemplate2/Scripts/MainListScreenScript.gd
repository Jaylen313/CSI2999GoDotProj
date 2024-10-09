extends Node2D


const MAX_CONTRACTS_PER_SECTION = 3


func _ready():
	
	$AddTask_GoalButton.connect("pressed", Callable(self, "_on_add_task_button_pressed"))
	$Contracts_Button.connect("pressed", Callable(self, "_on_contracts_button_pressed"))

	
	update_task_list()
	update_goal_list()


func _on_add_task_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/AddTaskScene.tscn")


func _on_contracts_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/ContractsScene.tscn")


func update_task_list():
	
	clear_section($VBoxContainer3)
	clear_section($VBoxContainer)
	clear_section($VBoxContainer2)

	
	add_contracts_to_section(GlobalScript.contracts, "Task", $VBoxContainer3, "Today")
	add_contracts_to_section(GlobalScript.contracts, "Task", $VBoxContainer, "Week")
	add_contracts_to_section(GlobalScript.contracts, "Task", $VBoxContainer2, "Month")


func update_goal_list():
	
	clear_section($VBoxContainer4)
	clear_section($VBoxContainer5)

	
	add_contracts_to_section(GlobalScript.contracts, "Goal", $VBoxContainer4, "Short Term")
	add_contracts_to_section(GlobalScript.contracts, "Goal", $VBoxContainer5, "Long Term")


func add_contracts_to_section(contract_list: Array, contract_type: String, section_node: Control, category: String):
	var count = 0

	for contract in contract_list:
		if count >= MAX_CONTRACTS_PER_SECTION:
			break  

		
		if contract["task_type"] == contract_type:
			if contract_type == "Task" and get_task_category(contract) == category:
				add_contract_node(section_node, contract)
				count += 1

			
			elif contract_type == "Goal" and get_goal_category(contract) == category:
				add_contract_node(section_node, contract)
				count += 1


func add_contract_node(parent_node: Control, contract: Dictionary):
	var contract_container = HBoxContainer.new()  

	
	var contract_checkbox = CheckBox.new()
	contract_checkbox.connect("toggled", Callable(self, "_on_contract_completed").bind(contract))

	
	var contract_label = Label.new()
	contract_label.text = "%s (%s)" % [contract["name"], contract["time"]]

	
	contract_container.add_child(contract_checkbox)
	contract_container.add_child(contract_label)

	
	parent_node.add_child(contract_container)


func _on_contract_completed(pressed: bool, contract: Dictionary):
	if pressed:
		
		GlobalScript.contracts.erase(contract)
		
		update_task_list()
		update_goal_list()


func get_task_category(contract: Dictionary) -> String:
	match contract["frequency"]:
		"Day":
			return "Today"
		"Week":
			return "Week"
		"Month":
			return "Month"
	return "Unknown"


func get_goal_category(contract: Dictionary) -> String:
	match contract["goal_type"]:
		"Short Term":
			return "Short Term"
		"Long Term":
			return "Long Term"
	return "Unknown"


func clear_section(section_node: Control):
	for child in section_node.get_children():
		section_node.remove_child(child)
		child.queue_free()
