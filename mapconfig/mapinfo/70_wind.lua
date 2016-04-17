--------------------------------------------------------------------------------------------------------
-- Wind settings
--------------------------------------------------------------------------------------------------------

if (Spring.GetMapOptions().wind == "high") then
	return { atmosphere = {
		minWind = 10,
		maxWind = 30,
	}}
elseif (Spring.GetMapOptions().wind == "low") then
	return { atmosphere = {
		minWind = 2,
		maxWind = 12,
	}}
end
