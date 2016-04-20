function widget:GetInfo()
	return {
		name	= "Cattle and Loveplay: Worm Lightning FX",
		desc	= "does worm lightning effects",
		author  = "eronoobos",
		date 	= "April 2016",
		license	= "whatever",
		layer 	= 0,
		enabled	= true
	}
end

local strikeDuration = 0.2 -- in seconds
local flashAge = 0.1
local flashEndAge = 0.15
local flashTex = "bitmaps/sworm_lightning_glow.png"
local flashSizeMult = 4

local strikes = {}

local lastX1, lastZ1, lastX2, lastZ2

local tRemove = table.remove
local mAtan2 = math.atan2
local mSin = math.sin
local mCos = math.cos
local mRandom = math.random
local mMin = math.min
local mMax = math.max
local mSqrt = math.sqrt
local mAbs = math.abs
local mDeg = math.deg

local pi = math.pi
local twicePi = math.pi * 2
local halfPi = math.pi / 2
local thirdPi = math.pi / 3
local twoThirdsPi = thirdPi * 2
local quarterPi = math.pi / 4
local eighthPi = math.pi / 8

local spGetTimer = Spring.GetTimer
local spDiffTimers = Spring.DiffTimers
local spGetGroundHeight = Spring.GetGroundHeight
local spWorldToScreenCoords = Spring.WorldToScreenCoords
local spIsAABBInView = Spring.IsAABBInView
local spIsSphereInView = Spring.IsSphereInView
local spGetLocalTeamID = Spring.GetLocalTeamID
local spGetTeamRulesParam = Spring.GetTeamRulesParam

local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList
local glColor = gl.Color
local glBeginEnd = gl.BeginEnd
local glVertex = gl.Vertex
local glPushMatrix = gl.PushMatrix
local glPopMatrix = gl.PopMatrix
local glDepthTest = gl.DepthTest
local glLineWidth = gl.LineWidth
local glTexRect = gl.TexRect
local glTexture = gl.Texture
local glBlending = gl.Blending
local glBillboard = gl.Billboard
local glTranslate = gl.Translate
local glNormal = gl.Normal
local glRotate = gl.Rotate

local GL_LINE_STRIP = GL.LINE_STRIP
local GL_TRIANGLE_STRIP = GL.TRIANGLE_STRIP
local GL_POINTS = GL.POINTS
local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN

local function normalizeVector2d(vx, vy)
	if vx == 0 and vy == 0 then return 0, 0 end
	local dist = mSqrt(vx*vx + vy*vy)
	return vx/dist, vy/dist, dist
end

local function normalizeVector3d(vx, vy, vz)
	if vx == 0 and vy == 0 and vz == 0 then return 0, 0, 0 end
	local dist = mSqrt(vx*vx + vy*vy + vz*vz)
	return vx/dist, vy/dist, vz/dist, dist
end

local function perpendicularVector2d(vx, vz)
	if mRandom(1,2) == 1 then
		return -vz, vx
	else
		return vz, -vx
	end 
end

local function AngleAdd(angle1, angle2)
  return (angle1 + angle2) % twicePi
end

local function CirclePos(cx, cy, dist, angle)
  angle = angle or mRandom() * twicePi
  local x = cx + dist * mCos(angle)
  local y = cy + dist * mSin(angle)
  return x, y
end

local function doLine3d(x1, y1, z1, x2, y2, z2)
    glVertex(x1, y1, z1)
    glVertex(x2, y2, z2)
end

local function doPoints2d(x, y)
	glVertex(x, y)
end

local function doCylinder(r, h, p)
	local rot = twicePi / p
	local pos = {}
	for a = 0, twicePi, rot do
		local x, z = CirclePos(0, 0, r, a)
		pos[#pos+1] = {x=x, z=z}
		if a ~= 0 then
			glVertex(x, 0, z)
		end
	end
	for i = 1, #pos do
		local p = pos[i]
		glVertex(p.x, 0, p.z)
		glVertex(p.x, h, p.z)
	end
	for i = 2, #pos do
		local p = pos[i]
		glVertex(p.x, h, p.z)
	end
end

local function drawSegment(x1, y1, z1, x2, y2, z2, r)
	glPushMatrix()
	-- glLineWidth(4)
	-- glColor(0, 0, 1, 1)
	-- glBeginEnd(GL_LINE_STRIP, doLine3d, x1, y1, z1, x2, y2, z2)
	glTranslate(x1, y1, z1)
	local dx, dy, dz = x2-x1, y2-y1, z2-z1
	local yAxisAngle = mDeg(mAtan2(-dz, dx))
	glRotate(yAxisAngle, 0, 1, 0)
	local distXZ = mSqrt(dx*dx + dz*dz)
	local zAxisAngle = mDeg(mAtan2(-distXZ, dy))
	glRotate(zAxisAngle, 0, 0, 1)
	local dist = mSqrt(dx*dx + dy*dy + dz*dz)
	glBeginEnd(GL_TRIANGLE_STRIP, doCylinder, r, dist+(r/2), 3)
	-- glLineWidth(2)
	-- glColor(1, 0, 0, 1)
	-- glBeginEnd(GL_LINE_STRIP, doLine3d, 0, 0, 0, 0, dist, 0)
	glPopMatrix()
end

local function drawLightningDisplayList(segments, radius)
	thickness = thickness or 0.75
	for i = 1, #segments do
		local seg = segments[i]
		drawSegment(seg.init.x, seg.init.y, seg.init.z, seg.term.x, seg.term.y, seg.term.z, radius)
	end
end

local function drawLightningFlash(x, y, z, size, color)
	glPushMatrix()
	glColor(color)
	glTexture(flashTex)
	glTranslate(x, y, z)
	glBillboard()
	glTexRect(-size, -size, size, size)
	glPopMatrix()
end

local function getLightningSegments(x1, z1, x2, z2, offsetMult, generationNum, branchProb, minOffsetMultXZ, minOffsetMultY)
	offsetMult = offsetMult or 0.4
	generationNum = generationNum or 5
	branchProb = branchProb or 0.2
	minOffsetMultXZ = minOffsetXZ or 0.05
	minOffsetMultY = minOffsetY or 0.1
	local y1, y2 = spGetGroundHeight(x1, z1), spGetGroundHeight(x2, z2)
	local ymin = mMin(y1, y2)
	local ymax = ymin
	local segmentList = { {init = {x=x1,y=y1,z=z1}, term = {x=x2,y=y2,z=z2}} }
	for g = 1, generationNum do
		local newSegmentList = {}
		for s = #segmentList, 1, -1 do
			local seg = tRemove(segmentList, s)
			local midX = (seg.init.x + seg.term.x) / 2
			local midY = (seg.init.y + seg.term.y) / 2
			local midZ = (seg.init.z + seg.term.z) / 2
			local vx, vz, dist = normalizeVector2d(seg.term.x-seg.init.x, seg.term.z-seg.init.z)
			local pvx, pvz = perpendicularVector2d(vx, vz)
			local offMax = dist * offsetMult
			local offsetXZ = mRandom(dist*minOffsetMultXZ, dist*offsetMult)
			midX, midZ = midX+(pvx*offsetXZ), midZ+(pvz*offsetXZ)
			midY = mMax( spGetGroundHeight(midX,midZ), midY+mRandom(dist*minOffsetMultY,offMax) )
			if midY > ymax then ymax = midY end
			local mid = {x=midX, y=midY, z=midZ}
			newSegmentList[#newSegmentList+1] = {init=seg.init, term=mid}
			newSegmentList[#newSegmentList+1] = {init=mid, term=seg.term}
			if mRandom() < branchProb then
				local angle = mAtan2(vz, vx)
				angle = AngleAdd(angle, (mRandom()*quarterPi)-eighthPi)
				local bx, bz = CirclePos(seg.init.x, seg.init.z, dist/2, angle)
				newSegmentList[#newSegmentList+1] = { init=seg.init, term={x=bx,y=seg.init.y,z=bz} }
			end
		end
		segmentList = newSegmentList
	end
	return segmentList, ymin, ymax
end

local function passWormLightning(x1, z1, x2, z2, offsetMult, generationNum, branchProb, minOffsetMultXZ, minOffsetMultY, thickness, glowThickness)
	thickness = thickness or 0.75 -- actually radius
	glowThickness = glowThickness or 3 -- actually radius
	local segments, y1, y2 = getLightningSegments(x1, z1, x2, z2, offsetMult, generationNum, branchProb, minOffsetMultXZ, minOffsetMultY)
	local first = segments[1].init
	local last = segments[#segments].term
	local r = mRandom()
	local coreColor = { 0.5+(r*0.5), 0.5, 0.5+((1-r)*0.5), 0.1 }
	local glowColor = { coreColor[1], 0, coreColor[3], 0.01 }
	local flashColor = { coreColor[1], coreColor[2], coreColor[3], 0.25}
	local radius = mMax( mAbs(x2-x1), mAbs(y2-y1), mAbs(z2-z1) ) / 2
	local x, y, z = (x1+x2) / 2, (y1+y2) / 2, (z1+z2) / 2
	local flashSize = radius * flashSizeMult
	local strike = {
		coreColor = coreColor,
		glowColor = glowColor,
		coreDisplayList = glCreateList(drawLightningDisplayList, segments, thickness),
		glowDisplayList = glCreateList(drawLightningDisplayList, segments, glowThickness),
		flashDisplayList = glCreateList(drawLightningFlash, x, y, z, flashSize, flashColor),
		timer = spGetTimer(),
	}
	strikes[#strikes+1] = strike
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("passWormLightning", passWormLightning)
end

function widget:GameFrame(gf)
	local myTeamID = spGetLocalTeamID()
	local x1 = spGetTeamRulesParam(myTeamID, "wormLightningX1")
	local z1 = spGetTeamRulesParam(myTeamID, "wormLightningZ1")
	local x2 = spGetTeamRulesParam(myTeamID, "wormLightningX2")
	local z2 = spGetTeamRulesParam(myTeamID, "wormLightningZ2")
	if x1 ~= lastX1 or z1 ~= lastZ1 or x2 ~= lastX2 or z2 ~= lastZ2 then
		passWormLightning(x1, z1, x2, z2)
	end
	lastX1, lastZ1, lastX2, lastZ2 = x1, z1, x2, z2
end

function widget:Update(dt)
	if #strikes == 0 then return end
	local cur = spGetTimer()
	for i = #strikes, 1, -1 do
		local s = strikes[i]
		local age = spDiffTimers(cur, s.timer)
		if age > strikeDuration then
			glDeleteList(s.coreDisplayList)
			glDeleteList(s.glowDisplayList)
			glDeleteList(s.flashDisplayList)
			tRemove(strikes, i)
		elseif age > flashEndAge then
			s.flash = false
			s.glowColor[4] = 0.01
			s.coreColor[4] = 0.1
		elseif age >= flashAge then
			s.flash = true
			s.glowColor[4] = 0.1
			s.coreColor[4] = 1.0
		end
	end
end

function widget:DrawWorld()
	if #strikes == 0 then return end
	glDepthTest(true)
	-- glPushMatrix()
	glBlending("alpha_add")
	for i = 1, #strikes do
		local s = strikes[i]
		glColor(s.glowColor)
		glCallList(s.glowDisplayList)
		glColor(s.coreColor)
		glCallList(s.coreDisplayList)
	end
	-- glPopMatrix()
	glDepthTest(false)
	for i = 1, #strikes do
		local s = strikes[i]
		if s.flash then
			glCallList(s.flashDisplayList)
		end
	end
	glDepthTest(true)
	glBlending("reset")
	glColor(1, 1, 1, 0.5)
end

function widget:Shutdown()
	for i = #strikes, 1, -1 do
		local s = strikes[i]
		glDeleteList(s.coreDisplayList)
		glDeleteList(s.glowDisplayList)
		glDeleteList(s.flashDisplayList)
	end
end