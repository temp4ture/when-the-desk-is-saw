extends Node

signal toggleDebugText
signal resizeCommandCalled(size: Vector2)

"""
    ###

    there was a bunch of bullshit planning on how i would go about this and there ended up being an addon that did literally
    everything i was planning on adding

    here you go

    https://github.com/4d49/godot-console


    this script just registers a bunch of commands and contains their the functions for their code

    to create a custom command, create a function that contains ur code, and then register it in _ready
    ###
"""

func _log(strang: String):
	return strang

func _cust(cmd: String):
	return cmd

func openskinfold():
	OS.shell_open(ProjectSettings.globalize_path("user://skin"))
func _setmood(val: float):
	gbData.data.save.mood = val
	gbData.savetodisk("user://SAVE.json", gbData.data)
	return val

func reload():
	get_tree().change_scene_to_file("res://scenes/newmain.tscn")


func spawnExpie(petId: String = ""):
	var path = "res://scenes/sawianBase.tscn"
	var scene = load(path)
	var instance = scene.instantiate()

	if petId == "":
		var skinName = GlobalVariable.userSkinPath.substr(0, len(GlobalVariable.userSkinPath) - 1) 
		skinName = skinName.substr(skinName.rfind("/") + 1) 
		petId = gbData.addPet(skinName)
	instance.get_node("behavior").petId = petId 

	var wrapper = Node2D.new()
	wrapper.scale = Vector2(4.0, 4.0)

	get_tree().current_scene.add_child(wrapper)
	wrapper.owner = get_tree().current_scene

	wrapper.add_child(instance)
	instance.owner = get_tree().current_scene

	instance.global_position.x = GlobalVariable.screenWidth / 2
	instance.global_position.y = - GlobalVariable.screenHeight * 2
	wrapper.set_meta("Category", "entity")


func _additem(item: String = "crate"):
# add crate only for now
	var path = "res://scenes/objects/" + item + ".tscn"
	if !ResourceLoader.exists(path):
		Console.error("No such object '" + item + "'")
		return
	var scene = load(path)
	var instance = scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = get_viewport().get_mouse_position()
	instance.owner = get_tree().current_scene
	instance.set_meta("itemName", item)


func clearObj(category: String = "object"):
	var exclude = [
		"Floor",
		"SideR",
		"SideL",
		"CanvasLayer",
		"CanvasLayer2"
	]
	

	for child in get_tree().current_scene.get_children():
		if not exclude.has(child.name):
			if category == child.get_meta("Category") or category == child.get_meta("itemName"):
				if gbData.data["saw"].has(child.get_meta("itemName")): #check if deleting a pet
					gbData.removePet(child.get_meta("itemName"))
				await get_tree().create_timer(.05).timeout
				child.queue_free()

	if category == "entity":
		gbData.data["saw"] = {}
		print("cleared pet persistence data")


func nukesettings():
	#command that fixes the "terror" bug
	gbData.killEverything()

func setmonitor(monitorIndex: int = 1):
	DisplayServer.window_set_current_screen(monitorIndex)
	GlobalVariable.Fresize()

func resize(nx, ny, isForce = "no") -> String:
	# transform string input into float output
	var ex = str(nx).to_float()
	var ey = str(ny).to_float()

	# deny windows too small unless forced
	# NOTE: we shouldnt be doing this anymore because the new terminal
	# clamps sizes too small and prevents the window from becoming non-existent
	if (ex < 200 or ey < 100) and isForce == "no":
		Console.warning("Resizing the console this small is not reccomended!")
		return "Type '[url=resizeConsole {0} {1} force]resizeConsole {0} {1} force[/url]' if you are sure".format([nx, ny])
	
	# if it goes through, call a resize
	var _target_size = Vector2(ex, ey)
	resizeCommandCalled.emit(_target_size)
	#save to config
	gbData.settings.ConsoleSize.x = ex
	gbData.settings.ConsoleSize.y = ey


	#debugshit
	if gbData.devMode == true:
		print(gbData.settings.ConsoleSize.x)
		print(gbData.settings.ConsoleSize.y)

	# please work please
	gbData.savetodisk("user://CONFIG.json", gbData.settings)
	return "resized"

func toggleExpieDebugIDs():
	toggleDebugText.emit()

func deathLoop():
	while true:
		Console.execute("log I_HATE_YOU")
		await get_tree().create_timer(.1).timeout

var _firstTimePopupMsg = false
## Show an output guide when generating a popup for the first time.
func _isFirstTimePopup():
	if !_firstTimePopupMsg:
		Console.print("[color=PURPLE]Popup output guide:[/color]")
		Console.print("[color=PURPLE]Yes = 1[/color]")
		Console.print("[color=PURPLE]No = 0[/color]")
		Console.print("[color=PURPLE]Closed = -1[/color]")
		_firstTimePopupMsg = true

func testPopup():
	_isFirstTimePopup()
	Console.print("Output from popup was '%s'!" % [await GlobalVariable.makePopUp()])

func testCreatePopup(
	title: String,
	text: String,
	yes_text: String = "Yes",
	no_text: String = "No",
	enable_no_button: bool = true,
	enable_close_button: bool = true,
	enable_resize_button: bool = true,
	size_x: int = 250,
	size_y: int = 180,
):
	Console.print("Output from popup was '%s'!" % [await GlobalVariable.makePopUp(title, text, Vector2(-1,-1), Vector2(size_x, size_y), yes_text, no_text, enable_no_button, enable_close_button, enable_resize_button)])

func _ready():
	Console.create_command("log", _log, "Log a string to the console.")
	Console.create_command("resizeConsole", resize, "resize the console")
	#dont use this it breaks alot of shit Console.create_command("reload", reload, "reload everything")
	Console.create_command("setMonitor", setmonitor, "temporary command")
	##Console.create_command("killExpie", killExpie, "Yeha")
	Console.create_command("setMood", _setmood, "debugging tool that doesnt work because i disabled mood stuff for this build")
	Console.create_command("spawn", _additem, "items: crate, sawblade that doesnt do anything. yeah thats all. sorry")
	Console.create_command("clearItems", clearObj, "clears by 'entity', 'object' or specific item name/ expie skin name.")
	Console.create_command("spawnExpie", spawnExpie, "please refer to the spawn menu rather than this command. Will be removed later")
	Console.create_command("openSkinFolder", openskinfold, "opens the skin folder")
	Console.create_command("nukeSettings", nukesettings, "run if your expie is in a constant state of terror (resets EVERYTHING)")
	Console.create_command("expieID", toggleExpieDebugIDs, "toggles debug IDs for expies")
	#Console.create_command("deathLoop", deathLoop, "please dont crash")
	Console.create_command("testPopup", testPopup, "shows a pop-up window for testing")
	Console.create_command("testCreatePopup", testCreatePopup, "make a pop-up of your own!")
