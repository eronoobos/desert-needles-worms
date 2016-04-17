--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- mapinfo.lua
--

local mapinfo = {
	name        = "Desert Needle Small With Worms",
	shortname   = "DNSWW41",
	description = "Desert map with soft sand and hard rocks. 2v2 to 4v4, 8 start positions. On rocks tanks/bots have a slightly higher speed (tanks:+20%,bots:+10%). Map options for metal, wind, feature values, time of day. Credits: Based on offical map blueprint container by jK; Skyboxes and some splat detail texes from smoth and Beherith; Features by smoth and 0ad from Spring Features 1.0 pack. Licence: Scripts GPL 2.0, map CC BY 3.0, features CC 3.0 BY-SA. Worms by eronoobos.",
	author      = "qray & eronoobos",
	version     = "4.1",
	--mutator   = "deployment";
	--mapfile   = "", --// location of smf/sm3 file (optional)
	modtype     = 3, --// 1=primary, 0=hidden, 3=map
	--depend      = {"Map Helper v1", "Spring Features 1.0",},
	depend      = {"Map Helper v1"},
	replace     = {},

	--startpic   = "", --// deprecated
	--StartMusic = "", --// deprecated

	maphardness     = 175,
	notDeformable   = false,
	gravity         = 130,
	tidalStrength   = 20,
    maxMetal        = 11.034,
    extractorRadius = 60,
	metalres        = 100,
	voidWater       = false,
	autoShowMetal   = true,


	smf = {
		minheight = -120,
		maxheight = 550,
		--smtFileName0 = "",
		--smtFileName1 = "",
		--smtFileName.. = "",
		--smtFileNameN = "",
	},

	sound = {
		--// Sets the _reverb_ preset (= echo parameters),
		--// passfilter (the direct sound) is unchanged.
		--//
		--// To get a list of all possible presets check:
		--//   https://github.com/spring/spring/blob/master/rts/System/Sound/EFXPresets.cpp
		--//
		--// Hint:
		--// You can change the preset at runtime via:
		--//   /tset UseEFX [1|0]
		--//   /tset snd_eaxpreset preset_name   (may change to a real cmd in the future)
		--//   /tset snd_filter %gainlf %gainhf  (may    "   "  "  "    "  "   "    "   )
		preset = "default",

		passfilter = {
			--// Note, you likely want to set these
			--// tags due to the fact that they are
			--// _not_ set by `preset`!
			--// So if you want to create a muffled
			--// sound you need to use them.
			gainlf = 1.0,
			gainhf = 1.0,
		},

		reverb = {
			--// Normally you just want use the `preset` tag
			--// but you can use handtweak a preset if wanted
			--// with the following tags.
			--// To know their function & ranges check the
			--// official OpenAL1.1 SDK document.
			
			--density
			--diffusion
			--gain
			--gainhf
			--gainlf
			--decaytime
			--decayhflimit
			--decayhfratio
			--decaylfratio
			--reflectionsgain
			--reflectionsdelay
			--reflectionspan
			--latereverbgain
			--latereverbdelay
			--latereverbpan
			--echotime
			--echodepth
			--modtime
			--moddepth
			--airabsorptiongainhf
			--hfreference
			--lfreference
			--roomrollofffactor
		},
	},

	resources = {
		--grassBladeTex = "",

		--grassShadingTex = "",
		--detailTex = "",
        specularTex = "specularmap_v04.png",
		splatDetailTex = "splattex.tga",
        splatDistrTex = "splatdistributionv04.png",
		--skyReflectModTex = "",
		--detailNormalTex = "",
		--lightEmissionTex = "",
	},

	splats = {
		texScales = {0.002, 0.002, 0.0001, 0.0014},
		texMults  = {0.5, 0.6, 0.15, 0.21},
	},

	atmosphere = {
 		minWind      =  5.0,
		maxWind      = 21.0,

		fogStart     = 0.65,
		fogEnd       = 0.9,
		fogColor     = {0.88, 0.84, 0.7},

		sunColor     = {1, 0.89, 0.29},
		skyColor     = {0.59, 1, 1},
		skyDir       = {0.0, 0.0, -1.0},
		skyBox       = "cleardesert.dds",

		cloudDensity = 0.3,
		cloudColor   = {0.78, 0.73, 0.68},
	},

	grass = {
		bladeWaveScale = 5.0,
		bladeWidth  = 0.52,
		bladeHeight = 5.0,
		bladeAngle  = 1.27,
		bladeColor  = {0.4, 1.0, 0.50}, --// does nothing when `grassBladeTex` is set
	},

	lighting = {
		--// dynsun
		sunStartAngle = 0.0,
		sunOrbitTime  = 1440.0,
		sunDir        = {-0.289, 0.84, 0.844},

		--// unit & ground lighting
		groundAmbientColor  = {0.70, 0.65, 0.65},
 		groundDiffuseColor  = {0.6, 0.55, 0.34},
		groundSpecularColor = {0.0001, 0.0001, 0.0001},
		groundShadowDensity = 0.4,
		unitAmbientColor    = {0.49, 0.49, 0.49},
		unitDiffuseColor    = {0.49, 0.49, 0.49},
		unitSpecularColor   = {0.7, 0.7, 0.7},
		unitShadowDensity   = 0.5,
		
		specularExponent    = 10.0,
	},
	
	water = {
		damage =  0.0,

		repeatX = 0.0,
		repeatY = 0.0,

		absorb    = {0.78, 0.59, 0.39},
		baseColor = {0.5, 0.7, 1},
		minColor  = {0.1, 0.3, 0.5},

		ambientFactor  = 0.1,
		diffuseFactor  = 0.8,
		specularFactor = 1.0,
		specularPower  = 10.0,

		planeColor = {0.6, 0.7, 1.0},

		surfaceColor  = {0.7, 0.8, 1.0},
		surfaceAlpha  = 0.01,
		diffuseColor  = {0.6, 0.7, 1.0},
		specularColor = {0.5, 0.6, 0.9},

		fresnelMin   = 0.2,
		fresnelMax   = 0.8,
		fresnelPower = 4.0,

		reflectionDistortion = 1.0,

		blurBase      = 2.0,
		blurExponent = 1.5,

		perlinStartFreq  =  50.0,
		perlinLacunarity = 2.0,
		perlinAmplitude  =  0.3,
		windSpeed = 1.0, --// does nothing yet

		shoreWaves = false,
		forceRendering = false,

		--// undefined == load them from resources.lua!
		--texture =       "",
		--foamTexture =   "",
		--normalTexture = "",
		--caustics = {
		--	"",
		--	"",
		--},
	},

	teams = {
		[0] = {startPos = {x = 2360, z = 5800}},
		[1] = {startPos = {x = 4808, z =  344}},
		[2] = {startPos = {x =  600, z = 4650}},
		[3] = {startPos = {x = 6568, z = 1494}},
		[4] = {startPos = {x = 2100, z = 4260}},
		[5] = {startPos = {x = 5068, z = 1884}},
		[6] = {startPos = {x =  460, z = 2730}},
		[7] = {startPos = {x = 6708, z = 3414}},
	},

	terrainTypes = {
		[0] = {
			name = "Rock",
			hardness = 4.0,
			receiveTracks = false,
			moveSpeeds = {
				tank  = 1.2,
				kbot  = 1.1,
				hover = 1.0,
				ship  = 1.0,
			},
		},
		[1] = {
			name = "Rock_medium",
			hardness = 3.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.1,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
		[2] = {
			name = "Rock_soft",
			hardness = 2.5,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
		[3] = {
			name = "SandOnRock_hard",
			hardness = 3.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
		[4] = {
			name = "SandOnRock_medium",
			hardness = 2.5,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
		[5] = {
			name = "SandOnRock_soft",
			hardness = 2.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
		[6] = {
			name = "Sand_Hard",
			hardness = 2.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
		[7] = {
			name = "Sand_medium",
			hardness = 1.5,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
		[8] = {
			name = "Sand_Soft",
			hardness = 1.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
		[9] = {
			name = "Sand_Soft",
			hardness = 1.0,
			receiveTracks = true,
			moveSpeeds = {
				tank  = 1.0,
				kbot  = 1.0,
				hover = 1.0,
				ship  = 1.0,
			},
		},				
	},

					
	custom = {
		fog = {
			color    = {0.99, 0.95, 0.80},
			height   = "100%", --// allows either absolue sizes or in percent of map's MaxHeight
			fogatten = 0.003,
		},
		precipitation = {
			density   = 30000,
			size      = 1.5,
			speed     = 50,
			windscale = 1.2,
			texture   = 'LuaGaia/effects/snowflake.png',
		},
	},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Helper

local function lowerkeys(ta)
	local fix = {}
	for i,v in pairs(ta) do
		if (type(i) == "string") then
			if (i ~= i:lower()) then
				fix[#fix+1] = i
			end
		end
		if (type(v) == "table") then
			lowerkeys(v)
		end
	end
	
	for i=1,#fix do
		local idx = fix[i]
		ta[idx:lower()] = ta[idx]
		ta[idx] = nil
	end
end

lowerkeys(mapinfo)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Map Options

if (Spring) then
	local function tmerge(t1, t2)
		for i,v in pairs(t2) do
			if (type(v) == "table") then
				t1[i] = t1[i] or {}
				tmerge(t1[i], v)
			else
				t1[i] = v
			end
		end
	end

	-- make code safe in unitsync
	if (not Spring.GetMapOptions) then
		Spring.GetMapOptions = function() return {} end
	end
	function tobool(val)
		local t = type(val)
		if (t == 'nil') then
			return false
		elseif (t == 'boolean') then
			return val
		elseif (t == 'number') then
			return (val ~= 0)
		elseif (t == 'string') then
			return ((val ~= '0') and (val ~= 'false'))
		end
		return false
	end

	getfenv()["mapinfo"] = mapinfo
		local files = VFS.DirList("mapconfig/mapinfo/", "*.lua")
		table.sort(files)
		for i=1,#files do
			local newcfg = VFS.Include(files[i])
			if newcfg then
				lowerkeys(newcfg)
				tmerge(mapinfo, newcfg)
			end
		end
	getfenv()["mapinfo"] = nil
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return mapinfo

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
