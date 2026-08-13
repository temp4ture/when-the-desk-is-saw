extends Panel

@export_category("Window")
@export var windowControl: WindowController

@export_category("Submenus")
@export var submenuButton: OptionButton
## Panels linked to the submenu picker options.
## Note that they have to be the same amount and in the same order as assigned to the SubmenuPîcker node.
@export var submenuPanels: Array[Node]

func _ready() -> void:
	# terminal things
	windowControl.shouldStoreResize = true
	InputManager.terminalOpenPressed.connect(_on_terminal_open_press)

	# show first (console) window by default
	submenuButton.item_selected.connect(_on_submenu_picker_item_selected)
	_on_submenu_picker_item_selected(0)

	if ( # its this ugly because i was unsure on how to config-toomfoolery-proof it
		gbData.settings
		and gbData.settings.ConsoleSize
		and gbData.settings.ConsoleSize.x
		and gbData.settings.ConsoleSize.y
	):
		windowControl.window_resize(
			Vector2(
				gbData.settings.ConsoleSize.x,
				gbData.settings.ConsoleSize.y
			)
		)
		print("%s: initial resize called properly!" % [name])

	run_intro_cmds()

func _on_terminal_open_press() -> void:
	if !visible:
		visible = true

func _on_submenu_picker_item_selected(index: int) -> void:
	for i in submenuPanels.size():
		if index == i:
			submenuPanels[i].show()
			continue
		submenuPanels[i].hide()

func run_intro_cmds() -> void:
	# i thought this had to be run from the console node itself but turns out its reflected on all consoles! hooray!
	Console.execute("setMonitor 0")
	Console.execute("help")
	Console.print("[color=PURPLE]You can reopen this console any time by Ctrl + Right Clicking on any Desksawian![/color]")
	Console.print("EXPIE OR ANY CHARACTERS THAT MAY BE PRESENT HERE ARE NOT MINE. THIS IS A FAN PROJECT")
	Console.print("IF YOU PAID FOR THIS OR GOT IT FROM SOMEWHERE NOT ON GITHUB, YOU DID IT WRONG!")
