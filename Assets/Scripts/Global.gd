extends Node

var WaveCompleted = true
var player_health: int = 50
var player_death: bool
var player_position = null
var enemy_position = null
var PlayerSpells = []
var PlayerItems = []
var PlayerCoins = 300
var DruidMenu = false
signal shoot
