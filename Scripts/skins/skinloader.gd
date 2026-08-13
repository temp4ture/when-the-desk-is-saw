## Imports external users skins and prepares them for usage.

var skinPath = "res://assets/Body"
var skinUserPath = GlobalVariable.userSkinPath

## If a skin is missing a limb texture, print to console?
var warnOnMissingAssets = true

# there must be a better way to do this....
var _expectedAssets = [
    "experimentCrus",
    "experimentDownArm",
    "experimentDownTorso",
    "experimentEyeClosed",
    "experimentEyeGone",
    "experimentEyeGoneHealed",
    "experimentEyeHalfClosed",
    "experimentEyeHalfClosedBack",
    "experimentEyeHappy",
    "experimentEyeLookBack",
    "experimentEyeOpen",
    "experimentEyePanic",
    "experimentEyeSad",
    "experimentEyeSadBack",
    "experimentEyeScared",
    "experimentEyeScaredBack",
    "experimentFoot",
    "experimentHandB",
    "experimentHandF",
    "experimentHead",
    "experimentHeadBack",
    "experimentHeadBackMouth",
    "experimentHeadBackMouthMini",
    "experimentHeadDisfigured1",
    "experimentHeadDisfigured1Healed",
    "experimentHeadDisfigured2",
    "experimentHeadDisfigured2Healed",
    "experimentHeadDisfigured3",
    "experimentHeadDisfigured3Healed",
    "experimentNosebleed",
    "experimentTail",
    "experimentThigh",
    "experimentUpArm",
    "experimentUpTorso",
]
var _is_busy = false

signal onSkinsLoaded()

## Prepare for skins to be reloaded.
## Function meant to be called by other scripts.
func ScheduleSkinReload():
    await load_skins()

var loadedSkinDict: Dictionary = {"name": "experimentRizz", "path": "path:/"}

## 
func load_skins():
    _is_busy = true
    var userskinstree: Array = DirAccess.get_files_at(skinUserPath)
    for path in userskinstree:
        print(path)

    var matches: Array[String] = []

    for asset in []:
        # ignore any asset we don't expect
        if not asset.name in _expectedAssets:
            continue
        matches += asset.name
    
    # 
    if len(matches) == len(_expectedAssets) and warnOnMissingAssets:
        push_warning("Missing assets when loading skin '%s'\nMissing: %s" % ["skin", matches-_expectedAssets])

    _is_busy = false
    onSkinsLoaded.emit()

## Look through the path's anatomy and load the proper assets.
func import_skin_folder(path: String):
    pass

## Unzip archives and pass their file tree to "import_skin_folder".
func import_skin_zip(path: String):
    var zread = ZIPReader.new()
    var err = zread.open(path)
    if err != OK:
        assert(false, "Path '%s' could not be opened.\n%s" % [path, err])
    var files = zread.get_files()
    print(files)
    zread.close()

    