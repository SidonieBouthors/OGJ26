extends Label

func increment_counter():
	self.text = str(Global.cycle_number)

func _ready():
	self.text = str(Global.cycle_number)
	Global.cycle_done.connect(increment_counter)
