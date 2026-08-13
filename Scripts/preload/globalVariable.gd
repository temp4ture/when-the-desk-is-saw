extends Node

#i probably shouldve put these here earlier but better late than never

#ill fix the scripts that redefine these when it bothers me enough
var screenWidth: int = DisplayServer.screen_get_usable_rect().size.x
var screenHeight: int = DisplayServer.screen_get_usable_rect().size.y

var taskbarPos: int = DisplayServer.screen_get_usable_rect().end.y

var clickZoneSum: int = 0
@warning_ignore("unused_signal") # seems to be used outside of this script?
signal persistenceWarning() # used to warn user if they have more than 20 expies stored in persistence save
signal raga()
signal skinswap()
signal resize()
signal pet(t: bool)
signal console(t: bool)
signal raisemood(t: int)
signal feed(t: int)
#signal bus shit this probably has like one thing in it
func petf(t: bool):
	pet.emit(t)
func Fresize():
	resize.emit()
func ragaa():
	raga.emit()
func skinswapFunc(data):
	skinswap.emit(data)

func consoleF(t: bool):
	console.emit(t)

func raisemoodF(t: int):
	raisemood.emit(t)

func feedf(t: int):
	feed.emit(t)

func _get_newmain_ui_canvas() -> CanvasLayer:
	var canvasName = "CanvasLayer2"
	var canvas: CanvasLayer = get_tree().current_scene.find_child(canvasName)
	if !canvas:
		push_error("popup: canvas '%s' could not be found. is this function being called outside newmain?" % [canvasName])
	return canvas

enum popupResultEnum {
	YES = 1,
	NO = 0,
	CLOSE = -1
}
func makePopUp(
	title: String = "Alert!",
	text: String = "[rainbow]Sample text[/rainbow]",
	position: Vector2 = Vector2(-1, -1), # -1 vector defaults to the center of the screen
	size: Vector2 = Vector2(250, 180),
	yes_text: String = "Yes",
	no_text: String = "No",
	enable_no_button: bool = true,
	enable_close_button: bool = true,
	enable_resize_button: bool = true,
	size_minimum: Vector2 = Vector2.ZERO,
	size_maximum: Vector2 = Vector2.INF
) -> popupResultEnum:
	var canvas = _get_newmain_ui_canvas()
	var popup: CustomPopup = load("res://scenes/ui/popUp.tscn").instantiate()
	canvas.add_child(popup)
	popup.owner = canvas
	# the chances of there being a better way of doing all this is...... considerable...
	popup.windowControl.minimumWindowSize = size_minimum
	popup.windowControl.maximumWindowSize = size_maximum
	popup.windowControl.window_resize(size)
	if position.x < 1 or position.y < 1:
		position = Vector2(
			(float(DisplayServer.screen_get_usable_rect().size.x) / 2) - (size.x / 2),
			(float(DisplayServer.screen_get_usable_rect().size.y) / 2) - (size.y / 2)
		)
	popup.position = position
	popup.titleText = title
	popup.labelText = text
	popup.yesButtonText = yes_text
	popup.noButtonText = no_text
	popup.update_labels()
	popup.enableNoButton = enable_no_button
	popup.enableCloseButton = enable_close_button
	popup.enableResizeButton = enable_resize_button
	popup.update_buttons()
	# record output!
	return await popup.hasPressedSignal

#just ignore this. pretend like i didnt waste time adding this and it just doesnt work
func _apply_renderer_and_restart(use_vulkan: bool) -> void:
	var method := "forward_plus" if use_vulkan else "gl_compatibility"
	ProjectSettings.set_setting("rendering/renderer/rendering_method", method)
	ProjectSettings.save()

	OS.set_restart_on_exit(true, OS.get_cmdline_args())

	gbData.settings.renderingMode = use_vulkan
	gbData.data["firstLaunch"] = false
	gbData.savetodisk("user://SAVE.json", gbData.data)
	gbData.savetodisk("user://CONFIG.json", gbData.settings)
	get_tree().quit()
#????????????????
var userSkinPath = "user://skin/Body/"


func getNumFromString(inputString: String):
	var number_string = ""
    
	for i in range(inputString.length()):
		var character = inputString[i]
		if character.is_valid_int():
			number_string += character
            
	return number_string