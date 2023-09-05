extends PanelContainer

onready var fileDialog := $MainFD
onready var noTextureLoaded := $TextureNotice
onready var mainContainer := $MainContainer
onready var fntDisplay := $MainContainer/VBoxContainer/HBoxContainer/fntDisplay
onready var charNameWnd := $charNamePopup
onready var charIdBox := $charNamePopup/CenterContainer/VBoxContainer/charIdLineEdit
onready var charList := $MainContainer/VBoxContainer/HBoxContainer/VBoxContainer/CharList
onready var cX := $MainContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/HBoxContainer/CharPosX
onready var cY := $MainContainer/VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/HBoxContainer2/CharPosY
onready var csX := $MainContainer/VBoxContainer/HBoxContainer2/HBoxContainer2/VBoxContainer/HBoxContainer/CharSizeX
onready var csY := $MainContainer/VBoxContainer/HBoxContainer2/HBoxContainer2/VBoxContainer/HBoxContainer2/CharSizeY
onready var ngd := $NoGlyphDialog
onready var oX := $MainContainer/VBoxContainer/HBoxContainer2/HBoxContainer3/VBoxContainer/HBoxContainer/CharOffsetX
onready var oY := $MainContainer/VBoxContainer/HBoxContainer2/HBoxContainer3/VBoxContainer/HBoxContainer2/CharOffsetY
onready var cH := $MainContainer/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/HBoxContainer3/HBoxContainer/FontHeight
onready var cSp := $MainContainer/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/HBoxContainer3/HBoxContainer2/CharSpacing

func _ready():
	for c in Global.chars:
		charList.add_item(char(c.character))
		
	charList.select(0)
	
func _process(_delta):
	var hasTexture = Global.fontTex != null
	
	noTextureLoaded.visible = !hasTexture
	mainContainer.visible = hasTexture
	
func _on_LoadTexBt_pressed():
	fileDialog.mode = FileDialog.MODE_OPEN_FILE
	fileDialog.set_filters(["*.png, *.jpg ; Image files"])
	fileDialog.popup()
	
	var path = yield(fileDialog, "file_selected")
	
	Global.fontName = path.get_file().get_basename()
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(path)
	
	image.compress(Image.COMPRESS_S3TC, Image.COMPRESS_SOURCE_GENERIC, 0.0)
	
	yield(get_tree(), "idle_frame")
	
	texture.create_from_image(image)
	
	Global.fontTex = texture
	fntDisplay.texture = texture

func _on_AddCharBt_pressed():
	charNameWnd.popup_centered_clamped(charNameWnd.rect_min_size)
	
	var character = yield(charIdBox, "text_entered")
	
	charNameWnd.hide()
	
	var curChars := []
	
	for i in range(charList.get_item_count()):
		curChars.append(charList.get_item_text(i))
	
	if character in curChars: return
	
	charList.add_item(character)
	
	generateChar(character)
	
	fntDisplay.update()
	
func generateChar(charString := ""):
	var newChar = BitmapCharacter.new(ord(charString))
	
	Global.chars.append(newChar)
	
func _on_CharList_item_selected(index):
	Global.selectedChar = index
	
	fntDisplay.update()
	
func evalReturn(stringExpr := ""):
	var expr := Expression.new()
	expr.parse(stringExpr)
	
	return expr.execute()
	
func _on_CharPosX_text_entered(new_text):
	if !Global.chars: return
	
	Global.chars[Global.selectedChar].bounds.position.x = evalReturn(new_text)
	cX.text = str(evalReturn(new_text))
	
	fntDisplay.update()
	
func _on_CharPosY_text_entered(new_text):
	if !Global.chars: return
	
	Global.chars[Global.selectedChar].bounds.position.y = evalReturn(new_text)
	cY.text = str(evalReturn(new_text))
	
	fntDisplay.update()
	
func _on_CharSizeX_text_entered(new_text):
	if !Global.chars: return
	
	Global.chars[Global.selectedChar].bounds.size.x = evalReturn(new_text)
	csX.text = str(evalReturn(new_text))
	
	fntDisplay.update()
	
func _on_CharSizeY_text_entered(new_text):
	if !Global.chars: return
	
	Global.chars[Global.selectedChar].bounds.size.y = evalReturn(new_text)
	csY.text = str(evalReturn(new_text))
	
	fntDisplay.update()

func _on_SaveBt_pressed():
	if !Global.chars.size():
		ngd.popup()
	else:
		fileDialog.mode = FileDialog.MODE_OPEN_DIR
		fileDialog.popup()
		fileDialog.set_filters([])
		
		var savePath = yield(fileDialog, "dir_selected")
		
		Global.saveProject(savePath)

func _on_CharOffsetX_text_entered(new_text):
	if !Global.chars: return
	
	Global.chars[Global.selectedChar].alignment.x = evalReturn(new_text)
	oX.text = str(evalReturn(new_text))

func _on_CharOffsetY_text_entered(new_text):
	if !Global.chars: return
	
	Global.chars[Global.selectedChar].alignment.y = evalReturn(new_text)
	oY.text = str(evalReturn(new_text))

func _on_FontHeight_text_entered(new_text):
	if !Global.chars: return
	
	Global.chars[Global.selectedChar].height = evalReturn(new_text)
	cH.text = str(evalReturn(new_text))

func _on_CharSpacing_text_entered(new_text):
	if !Global.chars: return
	
	Global.chars[Global.selectedChar].advance = evalReturn(new_text)
	cSp.text = str(evalReturn(new_text))

