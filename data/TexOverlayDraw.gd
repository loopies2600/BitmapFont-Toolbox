extends TextureRect

func _ready():
	update()
	
func _draw():
	if !Global.chars: return
	
	var curChar := Global.chars[Global.selectedChar] as BitmapCharacter
	
	draw_set_transform(Vector2(), 0.0, rect_size / texture.get_size())
	
	draw_rect(curChar.bounds, Color(1, 1, 1, 0.5), true)
