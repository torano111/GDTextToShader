extends Node
class_name OpenAIChatCompletion

signal chat_completed(end, content)

export(String, "gpt-3.5-turbo", "gpt-4") var model = "gpt-4"
export var temperature = 1.0

var is_completed = true
var url = "https://api.openai.com/v1/chat/completions"
var headers = ["Content-Type: application/json", "Authorization: Bearer "]
var http_request
var stream = false

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

func _http_request_completed(result, response_code, headers, body):
	print("result: " + str(result))
	
#	print("body: " + str(body))
	
	var str_body = body.get_string_from_utf8()
#	print("str_body: " + str_body)
	var response =  parse_json(str_body)
	
	# todo fix
	# this doesn't work if stream=true
#	for chunk in response:
#		print(chunk)

#	print("response: " + str(response))
#	print("content: " + response.choices[0].message.content)
	emit_signal("chat_completed", true, response.choices[0].message.content)
	is_completed = true
	
func send(api_key, messages):
	print("client_status: " + str(http_request.get_http_client_status()))
	
	var headers_with_api = headers.duplicate()
	headers_with_api[1] = headers_with_api[1] + api_key
	
	print("model: " + model)
	var body = to_json(
		{
			"model": model,
			"messages": messages,
			"temperature" : temperature,
			"stream" : stream
		}
	)
	
	is_completed = false
	var error = http_request.request(url, headers_with_api, true, HTTPClient.METHOD_POST, body)

	if error != OK:
		push_error("An error occurred in the HTTP request.")
		is_completed = true
		
static func get_api_key_env(env_api_key):
	if not OS.has_environment(env_api_key):
		push_error("Environment variable %s not found" % env_api_key)

	return OS.get_environment(env_api_key)
