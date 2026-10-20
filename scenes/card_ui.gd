@tool
class_name CardUI
extends Control

signal card_hovered(card_ui: CardUI)
signal card_unhovered(card_ui: CardUI)
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)

@onready var card_texture: TextureRect = $CardTexture
@onready var hitbox: Control = $Hitbox

@export var card_data: CardResource:
	set(new_data):
		card_data = new_data
		if is_inside_tree():
			update_ui()

var is_dragging: bool = false
var original_z_index: int = 0
var tween: Tween

func _ready() -> void:
	update_ui()
	
	# Connect Hitbox mouse signals
	if hitbox:
		hitbox.mouse_entered.connect(_on_mouse_entered)
		hitbox.mouse_exited.connect(_on_mouse_exited)
		hitbox.gui_input.connect(_on_gui_input)

func update_ui() -> void:
	if not card_data:
		return
	if card_texture and card_data.card_texture:
		card_texture.texture = card_data.card_texture

# --- Animation Helper ---
func animate_card(target_scale: Vector2, target_position_y: float, duration: float = 0.15) -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target_scale, duration)
	tween.tween_property(self, "position:y", target_position_y, duration)

# --- Mouse Events ---
func _on_mouse_entered() -> void:
	if is_dragging:
		return
	z_index = 10
	animate_card(Vector2(1.15, 1.15), -20.0)
	card_hovered.emit(self)

func _on_mouse_exited() -> void:
	if is_dragging:
		return
	z_index = original_z_index
	animate_card(Vector2(1.0, 1.0), 0.0)
	card_unhovered.emit(self)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drag()
		elif is_dragging:
			_stop_drag()

func _start_drag() -> void:
	is_dragging = true
	z_index = 20
	card_drag_started.emit(self)

func _stop_drag() -> void:
	is_dragging = false
	card_drag_ended.emit(self)
	z_index = original_z_index
	animate_card(Vector2(1.0, 1.0), 0.0)

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - (size * scale) / 2.0
