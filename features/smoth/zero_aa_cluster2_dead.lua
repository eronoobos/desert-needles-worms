-----------------------------------------------------------------------------
--  cluster2_dead
-----------------------------------------------------------------------------
local featureDef  =  {
   name           = "zero_aa_cluster2_dead",
   blocking       = true,
   category       = "Trees",
   damage            = 4000,
   description       = "Dead palm trees",
   energy            = 0,
   flammable         = 0,
   footprintX        = 4,
   footprintZ        = 4,
   upright           = true,
   height            = "36",
   hitdensity        = "5",
   metal          = 0,
   object            = "features/smoth/cluster2_dead.s3o",
   reclaimable       = true,
   autoreclaimable      = false,  
   crushResistance = 600,
   world          = "All Worlds",
	customparams = { 
		randomrotate		= "true", 
	}, 
}
return lowerkeys({[featureDef.name] = featureDef})
