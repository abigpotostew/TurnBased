

--Screen orientation code
local mainOr = "landscapeRight"
local altOr = "landscapeLeft"
local stage = display.getCurrentStage( )
stage:setReferencePoint(display.CenterReferencePoint)
local isRotated = false
local rotatefilter --function reserve
local rotatestart --function reserve
local rotatecomplete --function reserve
local curOrientation = mainOr --inital launch always match mainOr
local rota = 0
local isrotating = false
local rd = 600

-- iPad rotates slower
if system.getInfo("model") == "iPad" then rd = 750 end
 
function rotatefilter( )
        if (system.orientation == mainOr or system.orientation == altOr ) then
                return system.orientation
        else
                if curOrientation then return curOrientation else return mainOr end
        end
end

function rotatestart( val, initial )
        if isrotating == false and curOrientation ~= val then
                if val == mainOr then
                        rota = 180
                        curOrientation = mainOr
                elseif val == altOr then
                        rota = -180
                        curOrientation = altOr
                end
        isrotating = true
        if initial and rd == 750 then
        transition.to( stage, { rotation=rota, time=0, delta=true, onComplete=rotatecomplete } )
        else
        transition.to( stage, { rotation=rota, time=rd, delta=true, transition=easing.inOutQuad, onComplete=rotatecomplete } )
        end
        end
end
 
function rotatecomplete( )
        isrotating = false
        if curOrientation == altOr then isRotated = true else isRotated = false end
        if curOrientation ~= rotatefilter() then rotatestart(rotatefilter()) end
end
 
--Check initial orientation and and rotate if needed
if ( system.orientation == altOr and isrotating == false) then rotatestart(altOr,true) end
 
local function onOrientationChange( event )     
        local type = event.type
        if ( type == mainOr or type == altOr ) then rotatestart(type) end
end
 
Runtime:addEventListener( "orientation", onOrientationChange )