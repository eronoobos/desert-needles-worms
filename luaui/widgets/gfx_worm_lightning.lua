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

local strikeDuration = 30 -- in seconds
local flashDuration = 30
local flashTex = "bitmaps/sworm_lightning_glow.png"
local flashSizeMult = 4

local strikes = {}

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

local function doHalfPyramid(x1, y1, z1, x2, y2, z2, width)
	glVertex(x1, y1, z1)
	local vx, vy, vz, dist = normalizeVector3d(x2-x1, y2-y1, z2-z1)
	local halfDist = dist/2
	glRotate(90, vx, vy, vz)
	glVertex(width, halfDist, width)
	glRotate(90, vx, vy, vz)
	glVertex(width, halfDist, width)
	glRotate(90, vx, vy, vz)
	glVertex(width, halfDist, width)
	glRotate(90, vx, vy, vz)
	glVertex(width, halfDist, width)
end

-- local function DrawCylinder(r, h, p)
--     local theta1 = 0;
--     local ex,ey,ez = 0,0,0;
--     local px,py,pz = 0,0,0;

--     glBeginEnd( GL_TRIANGLE_STRIP , function()
--     for i = 0,p do
--         theta1 = i * TWOPI / p;
--                 ex = sin(theta1);
--                 ez = cos(theta1);
--                 px = cx + r * ex;
--                 py = cy;
--                 pz = cz + r * ez;
--                 -- glNormal( ex, 1, ez );
--                 -- glTexCoord( i/p , 0 );
--                 glVertex( px, py, pz );
--                 py = cy + h;
--                 -- glTexCoord( i/p, 1 );
--                 glVertex( px, py, pz );
--     end
--     end)
-- end

local function doRotationalCylinder(r, h, p)
	local rot = 360 / p
	for i = 0, p do
		glVertex(r, 0, 0)
		glVertex(r, h, 0)
		if i ~= p then glRotate(i*rot, 0, 1, 0) end
	end
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
	glBeginEnd(GL_TRIANGLE_STRIP, doCylinder, r, dist, 3)
	-- glLineWidth(2)
	-- glColor(1, 0, 0, 1)
	-- glBeginEnd(GL_LINE_STRIP, doLine3d, 0, 0, 0, 0, dist, 0)
	glPopMatrix()
end

local function pixelsPerElmoHere(x, y, z, elmos)
	elmos = elmos or 10
	local maxDistSq = 0
	local sx1, sy1 = spWorldToScreenCoords(s.x, s.y, s.z)
	for dx = -elmos, elmos, elmos do
		for dy = -elmos, elmos, elmos do
			for dz = -elmos, elmos, elmos do
				local sx2, sy2 = spWorldToScreenCoords(s.x, s.y, s.z)
				local distx = sx2 - sx1
				local disty = sy2 - sy1
				local distSq = (distx*distx) + (disty*disty)
				if distSq > maxDistSq then
					maxDistSq = distSq
				end
			end
		end
	end
	return mSqrt(maxDistSq)/elmos
end

local function drawLightningDisplayList(segments, coreColor, glowColor, thickness, glowThickness)
	thickness = thickness or 0.75
	glowThickness = glowThickness or 3
	for i = 1, #segments do
		local seg = segments[i]
		glBlending("add")
		glColor(glowColor)
		drawSegment(seg.init.x, seg.init.y, seg.init.z, seg.term.x, seg.term.y, seg.term.z, glowThickness)
		-- glBlending("add")
		glColor(coreColor)
		drawSegment(seg.init.x, seg.init.y, seg.init.z, seg.term.x, seg.term.y, seg.term.z, thickness)
		glBlending("reset")
	end
end

local function drawLightningFlash(s)
	if not spIsSphereInView(s.x, s.y, s.z, s.radius) then return end
	glPushMatrix()
	glBlending("alpha_add")
	glColor(s.flashColor)
	glTexture(flashTex)
	glTranslate(s.x, s.y, s.z)
	glBillboard()
	glTexRect(-s.flashSize, -s.flashSize, s.flashSize, s.flashSize)
	glBlending("reset")
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
				local bx, bz = CirclePos(seg.init.x, seg.init.z, dist*0.35, angle)
				newSegmentList[#newSegmentList+1] = { init=seg.init, term={x=bx,y=seg.init.y,z=bz} }
			end
		end
		segmentList = newSegmentList
	end
	return segmentList, ymin, ymax
end

local function passWormLightning(x1, z1, x2, z2, offsetMult, generationNum, branchProb, minOffsetMultXZ, minOffsetMultY, thickness, glowThickness)
	local segments, y1, y2 = getLightningSegments(x1, z1, x2, z2, offsetMult, generationNum, branchProb, minOffsetMultXZ, minOffsetMultY)
	local first = segments[1].init
	local last = segments[#segments].term
	local coreColor = { 1, 1, 1, 1 }
	local r = mRandom()
	local glowColor = { 0.5+(r*0.5), 0, 0.5+((1-r)*0.5), 0.05 }
	local fr = (coreColor[1] + glowColor[1]) / 2
	local fg = (coreColor[2] + glowColor[2]) / 2
	local fb = (coreColor[3] + glowColor[3]) / 2
	local flashColor = {fr, fg, fb, 0.15}
	local radius = mMax( mAbs(x2-x1), mAbs(y2-y1), mAbs(z2-z1) ) / 2
	local strike = {
		x = (x1+x2) / 2,
		y = (y1+y2) / 2,
		z = (z1+z2) / 2,
		radius = radius,
		flashSize = radius * flashSizeMult,
		fx1=fx1, fy1=fy1, fz1=fz1,
		fx2=fx2, fy2=fy2, fz2=fz2,
		coreColor = coreColor,
		glowColor = glowColor,
		flashColor = flashColor,
		displayList = glCreateList(drawLightningDisplayList, segments, coreColor, glowColor, thickness, glowThickness),
		timer = spGetTimer(),
	}
	strikes[#strikes+1] = strike
end

function widget:Initialize()
	widgetHandler:RegisterGlobal("passWormLightning", passWormLightning)
end

function widget:Update(dt)
	if #strikes == 0 then return end
	local cur = spGetTimer()
	for i = #strikes, 1, -1 do
		local s = strikes[i]
		local age = spDiffTimers(cur, s.timer)
		if age > flashDuration then
			tRemove(strikes, i)
		elseif age > strikeDuration then
			glDeleteList(s.displayList)
			s.noStrike = true
		end
	end
end

function widget:DrawWorld()
	if #strikes == 0 then return end
	glDepthTest(true)
	-- glPushMatrix()
	for i = 1, #strikes do
		local s = strikes[i]
		if not s.noStrike then
			glCallList(s.displayList)
		end
	end
	-- glPopMatrix()
	glDepthTest(false)
	for i = 1, #strikes do
		local s = strikes[i]
		drawLightningFlash(s)
	end
	glDepthTest(true)
	glColor(1, 1, 1, 0.5)
end