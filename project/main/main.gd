extends Node2D

# Declare our instanced child scenes.
@onready var battlemap := $Battlemap
@onready var cursor := $Cursor


func _ready():
	print("Main ready.")
