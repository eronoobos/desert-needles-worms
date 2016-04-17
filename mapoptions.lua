----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
-- File:        MapOptions.lua
-- Description: Custom MapOptions file that makes possible to set up variable options before game starts, like ModOptions.lua
-- Author:      SirArtturi, Lurker, Smoth, jK
----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
--	NOTES:
--	- using an enumerated table lets you specify the options order
--
--	These keywords must be lowercase for LuaParser to read them.
--
--	key:			the string used in the script.txt
--	name:		 the displayed name
--	desc:		 the description (could be used as a tooltip)
--	type:		 the option type
--	def:			the default value
--	min:			minimum value for number options
--	max:			maximum value for number options
--	step:		 quantization step, aligned to the def value
--	maxlen:	 the maximum string length for string options
--	items:		array of item strings for list options
--	scope:		'all', 'player', 'team', 'allyteam'			<<< not supported yet >>>
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local options = {
--// Sections

	
	{
		key  = 'Atmosphere',
		name = 'Atmosphere Settings',
		desc = 'Weather and time',
		type = 'section',
	},
	
	{
		key  = 'Economy',
		name = 'Economy Settings',
		desc = '',
		type = 'section',
	},	

--// Options
	


	
	--// Atmosphere
	{
		key  = "timeofday",
		name = "Time of day",
		desc = "Night or day?",
		type = "list",
		def  = "day",
		section = 'Atmosphere',
		items = {
			{ key = "dawn",  name = "Dawn",  desc = "Rising Sun" },
			{ key = "day",   name = "Day",   desc = "Full Daylight" },
			{ key = "night", name = "Night", desc = "Night Time" }
		},
	},
	
	--// Economy
	{
		key  = 'metal',
		name = 'Metal Production',
		desc = 'Metal production levels - How much metal is produced per spot',
		type = 'list',
		section = 'Economy',
		def  = 'normal',
		items	= {
			{ key = 'normal', name = "Normal", desc = "Metal density 100% (income 2 per spot)" },
			{ key = 'high', name = "High", desc = "Metal density +25% (income 2.5 per spot)" },
			{ key = 'low', name = "Low", desc = "Metal density -25% (income 1.5 per spot)"},
		},
	},

	{
		key   = 'wind',
		name  = 'Wind Speed',
		desc  = 'How strong wind will blow',
		type  = 'list',
		section = 'Economy',
		def   = 'normal',
		items = {
			{ key = 'normal', name = "Normal", desc = "Wind speed 5-21 (av. 13)" },
			{ key = 'high', name = "High", desc = "Wind speed 10-30 (av. 20)" },
			{ key = 'low', name = "Low", desc = "Wind speed 2-12 (av. 7)" },
		},
	},
	{
		key   = 'resourceperfeature',
		name  = 'Feature Resource Values',
		desc  = 'How much metal/energy the features will give when reclaimed',
		type  = 'list',
		section = 'Economy',
		def   = 'normal',
		items = {
			{ key = 'normal', name = "Normal", desc = "100 metal per rock, 90 energy per plant." },
			{ key = 'insane', name = "Insane", desc = "500 metal per rock + more rocks, 500 energy per plant." },
			{ key = 'none', name = "None", desc = "Zero metal/energy" },
		},
	},	

	
}

return options