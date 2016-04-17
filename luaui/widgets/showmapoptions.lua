--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    showmapoptions.lua
--  brief:   Shows map options before game start
--  author:  qray
--
--  Copyright (C) 2013.
--  Licensed under the terms of the GNU GPL, v2.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "ShowMapOptions",
    desc      = "Shows map options before game start",
    author    = "qray",
    date      = "Nov, 2013",
    license   = "GNU GPL, v2",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local vsx, vsy
local posx, posy
local SpringGetGameSeconds = Spring.GetGameSeconds
local glEndText = gl.EndText
local glText = gl.Text
local glBeginText = gl.BeginText
local v1, v2, v3, v4
local bx1, bx2, by1, by2
local metalperspot, windspeed, featureamount
local dhalfwidth = 220
local dheight= 30 * ( 6 ) + 5
local glcol=gl.Color
local glrec=gl.Rect
local gltexture = gl.Texture
local gltexrect = gl.TexRect
local gllineWidth = gl.LineWidth
local glshape = gl.Shape
local gllineloop = GL.LINE_LOOP
local glline = GL.LINES
local mapOptions = Spring.GetMapOptions()
local mpressstate=0
local movestate=0
local closeImg = ":a:bitmaps/map/wclosebuttonw.png" 
local modshortname = Game.gameShortName

function widget:Initialize()
	if (not Spring.GetModOptions()) then
		widgetHandler:RemoveWidget()
		return false
	end
    
    -- close widget if game is ZK; doesn't support map options
    if (modshortname == 'ZK') then
        widgetHandler:RemoveWidget()
        return false
    end    
    
	vsx, vsy = gl.GetViewSizes()
	posx = vsx * 0.5
	posy = vsy * 0.65
    
    bx1=posx+dhalfwidth-22
    by1=posy+28
    bx2=posx+dhalfwidth-2
    by2=posy+8
    
	v1 = { posx-dhalfwidth,posy+30 }
	v2 = { posx+dhalfwidth,posy+30 }
	v3 = { posx+dhalfwidth,posy-dheight }
	v4 = { posx-dhalfwidth,posy-dheight }  
end

function DrawScreen() -- test and fix
	
	if ( SpringGetGameSeconds() > 0  ) then
		widgetHandler:RemoveWidget(self)
	else
		glcol(0.3, 0.3, 0.3, 0.45)
		glrec(posx-dhalfwidth, posy+30, posx+dhalfwidth, posy-dheight)
		glcol(0, 0, 0, 0.8)
		gllineWidth(0.2)
		glshape(gllineloop, {
			{ v = v1},
			{ v = v2},
			{ v = v3},
			{ v = v4}
		})
		glBeginText()
		local psy = posy - 15 
		glText("Map Options", posx, psy, 20, "ocnd")
		psy = psy - 30
		local optsetting = "Normal"
		local metalperspot = "2.0"
		if (mapOptions["metal"] == "high" ) then
			metalperspot = "2.5"
			optsetting = "High"
		elseif (mapOptions["metal"] == "low" ) then
			metalperspot = "1.5"
			optsetting = "Low"
		end
		glText("Metal Spots: " .. optsetting .. " (" .. metalperspot .. " income per spot)", posx, psy, 18, "ocnd")
		psy = psy - 30
		optsetting = "Normal"
		local windspeedlow = "5"
		local windspeedhigh = "21"
		if (mapOptions["wind"] == "high") then
			windspeedlow = "10"
			windspeedhigh = "30"
			optsetting = "High"
		elseif (mapOptions["wind"] == "low") then
			windspeedlow = "2"
			windspeedhigh = "12"
			optsetting = "Low"
		end
		glText("Wind speed: " .. optsetting .. " (from " .. windspeedlow .. " to " .. windspeedhigh .. ")", posx, psy, 18, "ocnd")
		psy = psy - 30
		local psyy = psy - 30
		if (mapOptions["resourceperfeature"] == "insane") then
			glText("Feature Reclaim Values: Insane", posx, psy, 18, "ocnd")
			glText("(500 metal per rock, 500 energy per plant)", posx, psyy, 18, "ocnd")
		elseif (mapOptions["resourceperfeature"] == "none") then
			glText("Feature Reclaim Values: None", posx, psy, 18, "ocnd")
			glText("(rocks and plants unreclaimable)", posx, psyy, 18, "ocnd")
		else
			glText("Feature Reclaim Values: Normal", posx, psy, 18, "ocnd")
			glText("(100 metal per rock, 90 energy per plant)", posx, psyy, 18, "ocnd")

		end
		psy = psyy - 30
		glText("Speed bonus on rocks: tanks 20% / bots 10%", posx, psy, 18, "ocnd")
		psy = psy - 16
		glText("Move Window: middle mouse button", posx, psy, 9, "ocnd")
		glEndText()
        glcol(1,1,1, 1.0) 
        gltexture(closeImg)
        --gl.Billboard()  
        gltexrect(bx1,by1,bx2,by2)
        glcol(1,1,1, 1.0)        
	end
end


function widget:MousePress(x,y,button)
    if ( x > bx1 and x < bx2 and y < by1 and y > by2 and button==1) then
        mpressstate=1
        return true
    end
    if ( x > posx-dhalfwidth and x < posx+dhalfwidth and y < posy+30 and y > posy-dheight and button==2) then
        movestate=1
        return true
    end
end

             
function widget:MouseRelease(x, y, button)
    if (button==1 and mpressstate==1) then
        mpressstate=0
        widgetHandler:RemoveWidget()
        return false
    end
    if (button==2 and movestate==1) then
        movestate=0
    end    
end

function widget:MouseMove(x, y, dx, dy, button)
    if (button==2 and movestate==1) then
        posx=posx+dx
        posy=posy+dy
        bx1=posx+dhalfwidth-22
        by1=posy+28
        bx2=posx+dhalfwidth-2
        by2=posy+8
        v1 = { posx-dhalfwidth,posy+30 }
        v2 = { posx+dhalfwidth,posy+30 }
        v3 = { posx+dhalfwidth,posy-dheight }
        v4 = { posx-dhalfwidth,posy-dheight }         
    end
end
--------------------------------------------------------------------------------
