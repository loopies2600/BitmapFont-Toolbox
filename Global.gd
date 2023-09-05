extends Node

const EDITORSCN := preload("res://scenes/FontEditor.tscn")

const CHAR_STRUCT_LEN := 9

var fontTex : Texture setget _setFontTex
var chars := []
var selectedChar := 0
var fontName := "output"

func _setFontTex(value : Texture):
	fontTex = value
	fontTex.flags = 0
	
func loadProject(path := "user://output.font"):
	var myBmf := ResourceLoader.load(path) as BitmapFont
	
	var curChar := 0
	var charCnt := myBmf.chars.size()
	self.fontTex = myBmf.textures[0]
	
	fontName = path.get_file().get_basename()
	
	while (curChar != charCnt):
		var newChar := BitmapCharacter.new()
		
		newChar.character = myBmf.chars[curChar]
		newChar.bounds = Rect2(
			myBmf.chars[curChar + 2],
			myBmf.chars[curChar + 3],
			myBmf.chars[curChar + 4],
			myBmf.chars[curChar + 5])
			
		newChar.alignment = Vector2(
			myBmf.chars[curChar + 6],
			myBmf.chars[curChar + 7]
		)
		
		newChar.advance = myBmf.chars[curChar + 8]
		newChar.height = myBmf.height
		
		chars.append(newChar)
		
		curChar += CHAR_STRUCT_LEN
		
	get_tree().change_scene_to(EDITORSCN)
	
func saveProject(path := "user://"):
	var bmf := BitmapFont.new()
	bmf.add_texture(fontTex)
	
	for c in chars:
		bmf.add_char(c.character, 0, c.bounds, c.alignment, c.advance)
	
	bmf.height = chars[0].height
	
	ResourceSaver.save(path + "/%s.font" % fontName, bmf)
