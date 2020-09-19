extends Node

#Used when switching scenes to know which level was selected by the LevelManager
var selectedLevel

#[
# spriteFile, spriteWidth, spriteHeight
# hframes, vframes, desiredRotation
# colliderPosX, colliderPosY, colliderScaleX, colliderScaleY
# type, speedx, speedy, health
#]

var smallEnemy = [
	"res://Art/enemy-small.png", 16, 16,
	2, 1, 180,
	0, -2, 0.5, 0.6,
	"Small", 0, 40, 1
]
var mediumEnemy = [
	"res://Art/enemy-medium.png", 32, 16,
	2, 1, 180,
	0, 0, 1.6, 0.75,
	"Medium", 60, 40, 2
]
var largeEnemy = [
	"res://Art/enemy-big.png", 32, 32,
	2, 1, 180,
	0, -6, 1, 1,
	"Large", 40, 30, 3
]

#===================
#	Level Setup
#===================

var levelSetup = {
	1: {
		"enemyOrder": [
			"Small","Small","Small",
			"Small","Small","Small",
			"Shield",
			"Small","Small","Small",
			"Bullet",
			"Medium",
			"Small","Small","Small",
			"Medium","Medium"
		],
		"timeBetween": [
			1.75, 1.75, 1.75,
			1.5, 1.5, 1.5,
			0.2,
			1.5, 1.5, 1.5,
			0.2,
			1.5,
			1.25, 1.25, 1.25,
			1.25, 1.25,
		]
	},
	2: {
		"enemyOrder": [
			"Small","Small",
			"Medium","Medium",
			"Shield",
			"Small","Small",
			"Medium","Medium",
			"Shield",
			"Small","Small","Small","Small",
			"Medium","Medium","Medium","Medium",
			"Small","Small","Small","Small",
			"Medium","Medium","Medium","Medium"
		],
		"timeBetween": [
			1.5, 1.5,
			1.5, 1.5,
			0.2,
			1.25, 1.25,
			1.25, 1.25,
			0.2,
			1, 1, 1, 1,
			1, 1, 1, 1,
			0.8, 0.8, 0.8, 0.8,
			0.8, 0.8, 0.8, 0.8
		]
	},
	3: {
		"enemyOrder": [
			"Medium","Medium","Medium",
			"Small","Small","Small","Small",
			"Medium","Medium","Medium",
			"Bullet",
			"Small","Small","Small","Small",
			"Medium","Medium","Medium","Medium","Medium","Medium",
			"Small","Small","Small","Small"
		],
		"timeBetween": [
			1.25, 1.25, 1.25,
			1, 1, 1, 1,
			0.75, 0.75, 0.75,
			0.5,
			0.75, 0.1, 0.1, 0.75,
			0.75, 0.75, 0.75, 0.75, 0.75, 0.75,
			0.5, 0.5, 0.5, 0.5
		]
	},
	4: {
		"enemyOrder": [
			#wave 1
			"Small","Small",
			"Medium","Medium",
			"Small","Small",
			"Shield",
			"Medium","Medium",
			"Large",
			#wave 2
			"Small","Small",
			"Medium","Medium",
			"Small","Small",
			"Shield",
			"Medium","Medium",
			"Large",
			"Medium","Medium","Medium","Medium"
		],
		"timeBetween": [
			#wave 1
			1.25, 1.25,
			1.25, 1.25,
			1, 0.2,
			1,
			1, 2,
			1.5,
			#wave 2
			1.25, 1.25,
			1, 1,
			1.25, 0.2,
			1,
			1.25, 2,
			1.5,
			1.25, 1.25, 1.25, 1.25
		]
	},
	5: {
		"enemyOrder": [
			#wave 1
			"Small","Small","Small",
			"Medium","Medium","Medium",
			"Large",
			"Bullet",
			"Shield",
			"Small","Small","Small",
			"Medium","Medium","Medium",
			#wave 2
			"Small","Small","Small",
			"Medium","Medium","Medium",
			"Large","Large",
			"Shield",
			"Small","Small","Small",
			"Medium","Medium","Medium","Medium","Medium","Medium"
		],
		"timeBetween": [
			#wave 1
			1.5, 1.5, 1.5,
			1.25, 1.25, 1.5,
			0.2,
			0.2,
			0.2,
			1.25, 1.25, 1.25,
			1.25, 1.25, 1.25,
			#wave 2
			1, 1, 1, 1,
			1.25, 1.25, 1.5,
			1.75, 1.75,
			1.5,
			1.25, 1.25, 1.25,
			1.25, 1.25, 1.25, 1.25, 1.25, 1.25
		]
	},
	6: {
		"enemyOrder": [
			#wave 1
			"Small","Small",
			"Medium","Medium","Medium","Medium",
			"Shield",
			"Large",
			"Small","Small",
			#wave 2
			"Medium","Medium","Medium","Medium",
			"Large","Large",
			"Bullet",
			"Shield",
			"Medium","Medium","Medium","Medium","Medium","Medium",
			"Large","Large",
			"Medium","Medium","Medium","Medium","Medium","Medium"
		],
		"timeBetween": [
			#wave 1
			1, 1,
			1.25, 1.25, 1.25, 1.25,
			0.2,
			1.5,
			1, 1,
			#wave 2
			1.25, 1.25, 1.25, 1.25,
			1.25, 1.25,
			0.2,
			0.2,
			1.25, 1.25, 1.25, 1.25, 1.25, 1.25,
			1.25, 1.25,
			1, 1, 1, 1, 1, 1
		]
	},
	7: {
		"enemyOrder": [
			#wave 1
			"Medium","Medium","Medium",
			"Large",
			"Shield",
			"Medium","Medium","Medium","Medium",
			"Large",
			"Medium","Medium","Medium","Medium","Medium","Medium",
			"Large", "Large",
			#wave 2
			"Medium","Medium","Medium",
			"Large",
			"Shield",
			"Medium","Medium","Medium","Medium",
			"Large",
			"Bullet",
			"Medium","Medium","Medium","Medium","Medium","Medium",
			"Large", "Large",
			#wave 3
			"Medium","Medium","Medium",
			"Large", "Large",
			"Bullet",
			"Shield",
			"Medium","Medium","Medium","Medium",
			"Large", "Large",
			"Medium","Medium","Medium","Medium","Medium","Medium",
			"Large", "Large", "Large"
		],
		"timeBetween": [
			#wave 1
			1.5, 1.5, 1.5,
			1.25,
			1.25,
			1.25, 1.25, 1.25, 1.25,
			1.25,
			1.25, 1.25, 1.25, 1.25, 1.25, 1.25,
			1.25, 1.25,
			#wave 2
			1.25, 1.25, 1.25,
			1.25,
			1.25,
			1.15, 1.15, 1.15, 1.15,
			1.15,
			1.15,
			1.15, 1.15, 1.15, 1.15, 1.15, 1.15,
			1.15, 1.15,
			#wave 3
			1.25, 1.25, 1.25,
			1.25, 1.25,
			1,
			1,
			1.15, 1.15, 1.15, 1.15,
			1.15, 1.15,
			1.15, 1.15, 1.15, 1.15, 1.15, 1.15,
			1.15, 1.15, 1.15
		]
	}
}
