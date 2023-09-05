extends Resource
class_name BitmapCharacter

var character := 0 # UNICODE ID
var bounds := Rect2()
var alignment := Vector2()
var advance := -1
var height := 0

func _init(i_char := 0, i_bnds := Rect2(), i_align := Vector2(), i_adv := -1):
	character = i_char
	bounds = i_bnds
	alignment = i_align
	advance = i_adv
