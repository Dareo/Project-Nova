extends PanelContainer


@onready var PropertyContainer = %VBoxContainer

var FPS : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Debug.DebugPannel = self

func _input(event: InputEvent) -> void:
	# Toggle debug pannel
	if event.is_action_pressed("Debug"):
		visible = !visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		return
	FPS = "%.2f" % (1.0/delta)
	AddProperty("FPS", FPS, 0)

func AddProperty(title : String, value, order):
	var target
	target = PropertyContainer.find_child(title,true, false)
	if !target:
		target = Label.new()
		PropertyContainer.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif  visible:
		target.text =  title + ": " + str(value)
		PropertyContainer.move_child(target,order)

