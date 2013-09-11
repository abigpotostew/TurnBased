--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b99f1574fe2b524efb5366db756d9208$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- badpipe
            x=282,
            y=243,
            width=68,
            height=68,

        },
        {
            -- city
            x=211,
            y=2,
            width=132,
            height=132,

        },
        {
            -- downstop
            x=72,
            y=408,
            width=68,
            height=68,

        },
        {
            -- energy
            x=72,
            y=338,
            width=68,
            height=68,

        },
        {
            -- grass
            x=2,
            y=408,
            width=68,
            height=68,

        },
        {
            -- horizontal
            x=2,
            y=338,
            width=68,
            height=68,

        },
        {
            -- leftdown
            x=422,
            y=173,
            width=68,
            height=68,

        },
        {
            -- leftstop
            x=352,
            y=173,
            width=68,
            height=68,

        },
        {
            -- lefttop
            x=72,
            y=268,
            width=68,
            height=68,

        },
        {
            -- overlay
            x=2,
            y=268,
            width=68,
            height=68,

        },
        {
            -- pipe
            x=2,
            y=2,
            width=207,
            height=54,

        },
        {
            -- pipe100
            x=345,
            y=2,
            width=104,
            height=29,

        },
        {
            -- pollution
            x=212,
            y=206,
            width=68,
            height=68,

        },
        {
            -- pollution_coal
            x=142,
            y=206,
            width=68,
            height=68,

        },
        {
            -- pollution_geothermal
            x=282,
            y=173,
            width=68,
            height=68,

        },
        {
            -- pollution_nuclear
            x=72,
            y=198,
            width=68,
            height=68,

        },
        {
            -- pollution_solar
            x=2,
            y=198,
            width=68,
            height=68,

        },
        {
            -- pollution_water
            x=212,
            y=136,
            width=68,
            height=68,

        },
        {
            -- pollution_wind
            x=142,
            y=136,
            width=68,
            height=68,

        },
        {
            -- rightdown
            x=72,
            y=128,
            width=68,
            height=68,

        },
        {
            -- rightstop
            x=2,
            y=128,
            width=68,
            height=68,

        },
        {
            -- righttop
            x=72,
            y=58,
            width=68,
            height=68,

        },
        {
            -- stone
            x=2,
            y=58,
            width=68,
            height=68,

        },
        {
            -- tower
            x=415,
            y=103,
            width=68,
            height=68,

        },
        {
            -- upstop
            x=345,
            y=103,
            width=68,
            height=68,

        },
        {
            -- vertical
            x=415,
            y=33,
            width=68,
            height=68,

        },
        {
            -- water
            x=345,
            y=33,
            width=68,
            height=68,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["badpipe"] = 1,
    ["city"] = 2,
    ["downstop"] = 3,
    ["energy"] = 4,
    ["grass"] = 5,
    ["horizontal"] = 6,
    ["leftdown"] = 7,
    ["leftstop"] = 8,
    ["lefttop"] = 9,
    ["overlay"] = 10,
    ["pipe"] = 11,
    ["pipe100"] = 12,
    ["pollution"] = 13,
    ["pollution_coal"] = 14,
    ["pollution_geothermal"] = 15,
    ["pollution_nuclear"] = 16,
    ["pollution_solar"] = 17,
    ["pollution_water"] = 18,
    ["pollution_wind"] = 19,
    ["rightdown"] = 20,
    ["rightstop"] = 21,
    ["righttop"] = 22,
    ["stone"] = 23,
    ["tower"] = 24,
    ["upstop"] = 25,
    ["vertical"] = 26,
    ["water"] = 27,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
