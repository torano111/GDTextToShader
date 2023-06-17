extends Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	var shader_code = """
	"""
#	update_shader_code(shader_code)


func update_shader_code(code):
	material.shader.code = code
