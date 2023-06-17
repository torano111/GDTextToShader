extends Node

export var env_api_key = "OPENAI_API_KEY"
export(String, "gpt-3.5-turbo", "gpt-4") var model = "gpt-4"
export(String, MULTILINE) var prompt_shader_generator

var api_key = ""
var shader_generator;

func _ready():
	$HUD.set_text("")
	
	api_key = OpenAIChatCompletion.get_api_key_env(env_api_key)
	
	shader_generator = OpenAIChatCompletion.new()
	shader_generator.model = model
	add_child(shader_generator)
	shader_generator.connect("chat_completed", self, "_on_open_ai_chat_completion_chat_completed")

func _on_HUD_on_message_sent(message):
	if !message.empty() and shader_generator.is_completed:
		print("user: " + message)
		
		$HUD.set_text("")
		assert(!prompt_shader_generator.empty())
		shader_generator.send(api_key, [
			{"role": "system", "content": prompt_shader_generator},
			{"role": "user", "content": message}
		])
		$HUD/Button.set_disabled(true)
			
func _on_open_ai_chat_completion_chat_completed(end, content):
#	print("assistant: " + content)
#	var prev_text = $HUD/RichTextLabel.get_text()
	$HUD.set_text(content)
	$HUD/RuntimeShader.update_shader_code(content)
	$HUD/Button.set_disabled(false)
