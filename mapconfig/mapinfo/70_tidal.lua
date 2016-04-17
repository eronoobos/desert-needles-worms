--------------------------------------------------------------------------------------------------------
-- Tidal settings
--------------------------------------------------------------------------------------------------------

if (Spring.GetMapOptions().tidal == "low") then
	return {
		tidalStrength = (mapinfo.tidalstrength or 5) * 0.50,
	}
elseif (Spring.GetMapOptions().tidal == "less") then
	return {
		tidalStrength = (mapinfo.tidalstrength or 5) * 0.75,
	}
end
