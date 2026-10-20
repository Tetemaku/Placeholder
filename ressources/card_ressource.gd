class_name CardResource
extends Resource

enum TargetType {
	SELF,
	SINGLE_ENEMY,
	ALL_ENEMIES,
	NONE
}

@export_category("Card Info")
@export var card_id: String = ""
@export var card_name: String = "Card Name"
@export var description: String = "Effect description goes here."
@export var card_texture: Texture2D

@export_category("Costs & Targeting")
@export var cost: int = 1
@export var target_type: TargetType =TargetType.SINGLE_ENEMY

@export_category("Card Stats / Effects")
@export var damage: int = 0
@export var block: int = 0
