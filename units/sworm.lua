return {
	sworm1 = {
		blocking = true,
		buildPic = "sworm.png",
		canMove = true,
		-- category = "ALL MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		description = "Hungry beast.",
		footprintX = 5,
		footprintZ = 5,
		hideDamage = true,
		iconType = "sworm",
		levelGround = false,
		maxDamage = 2000000,
		name = "Sand Worm",
		objectName = "swormTrilipClosedMouth-20below.s3o",
		script = [[sWormTrilipClosedMouthScaling.lua]],
		-- collisionvolumeoffsets = {0, 40, 0},
 		usePieceCollisionVolumes = true,
		customParams = {
 			ignoreplacementrestriction = true,
		},
	},
	sworm2 = {
		blocking = true,
		buildPic = "sworm.png",
		canMove = true,
		-- category = "ALL MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		description = "Hungry, with an unsophisticated palatte.",
		footprintX = 10,
		footprintZ = 10,
		hideDamage = true,
		iconType = "sworm",
		levelGround = false,
		maxDamage = 3000000,
		name = "Sand Worm",
		objectName = "swormTrilipClosedMouth-20below-scale2x.s3o",
		script = [[sWormTrilipClosedMouthScaling.lua]],
 		usePieceCollisionVolumes = true,
		customParams = {
 			ignoreplacementrestriction = true,
		},
	},
	sworm3 = {
		blocking = true,
		buildPic = "sworm.png",
		canMove = true,
		-- category = "ALL MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		description = "Large and in charge.",
		footprintX = 15,
		footprintZ = 15,
		hideDamage = true,
		iconType = "sworm",
		levelGround = false,
		maxDamage = 4000000,
		name = "Sand Worm",
		objectName = "swormTrilipClosedMouth-20below-scale3x.s3o",
		script = [[sWormTrilipClosedMouthScaling.lua]],
 		usePieceCollisionVolumes = true,
		customParams = {
 			ignoreplacementrestriction = true,
		},
	},
	sworm4 = {
		blocking = true,
		buildPic = "sworm.png",
		canMove = true,
		-- category = "ALL MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		description = "Shy. Who? Lewd.",
		footprintX = 20,
		footprintZ = 20,
		hideDamage = true,
		iconType = "sworm",
		levelGround = false,
		maxDamage = 5000000,
		name = "Sand Worm",
		objectName = "swormTrilipClosedMouth-20below-scale4x.s3o",
		script = [[sWormTrilipClosedMouthScaling.lua]],
 		usePieceCollisionVolumes = true,
		customParams = {
 			ignoreplacementrestriction = true,
		},
	},
	underworm = {
		blocking = false,
		buildPic = "sworm.png",
		canMove = true,
		canCloak = true,
		cloakTimeout = 1,
		-- category = "ALL MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE",
		description = "I'd like to be under the sand in a worm's garden.",
		footprintX = 4,
		footprintZ = 4,
		hideDamage = true,
		iconType = "underworm",
		levelGround = false,
		maxDamage = 6000000,
		name = "Sand Worm Under Sand",
		objectName = "invisible30x10.s3o",
		reclaimable = false,
		script = [[nullscript.lua]],
		customParams = {
 			ignoreplacementrestriction = true,
		},
	},
	wormtrigger = {
		blocking = false,
		buildPic = "sworm.png",
		canMove = true,
		description = "I bring the worm.",
		footprintX = 1,
		footprintZ = 1,
		iconType = "underworm",
		levelGround = false,
		maxDamage = 9999,
		name = "Sand Worm Trigger",
		objectName = "invisible30x10.s3o",
		script = [[nullscript.lua]],
		canFly = true,
		cruiseAlt = 160,
		customParams = {
 			ignoreplacementrestriction = true,
		},
	},
}
