extends Node2D

var EnemyScene: PackedScene = preload("res://scenes/enemy.tscn")


func spawn_enemy(position: Vector2) -> Node2D:
	var enemy = EnemyScene.instantiate()
	add_child(enemy)
	enemy.global_position = position
	return enemy

func _on_timer_timeout() -> void:
	spawn_enemy(Vector2(0, 0))
	print("hehe")
