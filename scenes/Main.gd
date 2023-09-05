extends PanelContainer

onready var fileDialog := $MainFD

func _on_NProj_pressed():
	get_tree().change_scene_to(Global.EDITORSCN)

func _on_LProj_pressed():
	fileDialog.mode = FileDialog.MODE_OPEN_FILE
	fileDialog.set_filters(["*.font ; BitmapFont Resource"])
	fileDialog.popup()
	
	var path = yield(fileDialog, "file_selected")
	
	Global.loadProject(path)
