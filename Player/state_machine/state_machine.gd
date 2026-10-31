extends StateMachine

@onready var muzzle :Node3D = owner.get_node('Muzzle')


func _process(_delta: float) -> void:
	super._process(_delta)

	debug_label()





func debug_label()->void:
	#DEBUG
	var label: Label = %DebugLabel
	label.text = str(
		'state: ', current_state.name,
		
		
		)
	#----------------	
