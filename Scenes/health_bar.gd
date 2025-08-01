extends Control

var _PLAYER: Player
var _CURRENT_HEALTH: int 

var health_bar: TextureProgressBar
var health: Label

func _ready() -> void:
	_PLAYER = get_parent()
	_CURRENT_HEALTH = _PLAYER.MAX_HEALTH
	
	health_bar = $%HealthBar
	health_bar.max_value = _PLAYER.MAX_HEALTH
	health_bar.value = _CURRENT_HEALTH
	
	health = $%Health
	health.text = "%s / %s" % [_CURRENT_HEALTH, _PLAYER.MAX_HEALTH]

func _on_damage_taken(damage: int) -> void:
	_CURRENT_HEALTH -= damage
	if _CURRENT_HEALTH <= 0:
		_PLAYER.queue_free()
	health_bar.value = _CURRENT_HEALTH
	health.text = "%s / %s" % [_CURRENT_HEALTH, _PLAYER.MAX_HEALTH]
