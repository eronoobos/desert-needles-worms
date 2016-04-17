--------------------------------------------------------------------------------------------------------
-- Metal settings
--------------------------------------------------------------------------------------------------------

if (Spring.GetMapOptions().metal == "high") then
	return {
		maxmetal = (mapinfo.maxmetal or 0.02) * 1.25,
	}
elseif (Spring.GetMapOptions().metal == "low") then
	return {
		maxmetal = (mapinfo.maxmetal or 0.02) * 0.75,
	}
end
