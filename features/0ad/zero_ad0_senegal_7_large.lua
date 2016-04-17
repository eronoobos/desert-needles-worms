local objectname= "zero_ad0_senegal_7_large" 
local featureDef	=	{
	name			= "zero_ad0_senegal_7_large",
	world				="All Worlds",
	description				="Palm Tree",
	category				="Vegetation",
	object				="features/0ad/ad0_senegal_7_large.s3o",
	footprintx				=2,
	footprintz				=2,
	height				=30,
	blocking				=true,
	upright				=true,
	hitdensity				=0,
	energy				=0,

	crushResistance = 1300,
	damage = 1300,
	indestructable = true,
	flammable				=true,
	reclaimable				 = false,
	autoreclaimable				 = false,
	featurereclamate				="smudge01",
	seqnamereclamate				="tree1reclamate",
	customparams = { 
		randomrotate		= "true", 
	}, 
}
return lowerkeys({[objectname] = featureDef}) 
