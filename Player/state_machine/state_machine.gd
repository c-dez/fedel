extends StateMachine


func _process(_delta: float) -> void:
	super._process(_delta)
	#DEBUG
	var label: Label = %DebugLabel
	label.text = str(
		'state: ', current_state.name,
		
		)
	#----------------	