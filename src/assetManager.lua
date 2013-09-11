--local spAnimInfo = require "src.libs.swiftping.sp_animinfo"
local audio = require "audio"

local AssetManager = {}
local assetStack = {}
local handlers = {}

handlers["anim"] = {
	load = function(path)
		return spAnimInfo:load(path)
	end,
	unload = function(asset)
		asset:dispose()
	end,
}

handlers["sound"] = {
	load = function(path)
		return audio.loadSound(path)
	end,
	unload = function(asset)
		audio.dispose(asset)
	end,
}

local function currentFrame()
	return assetStack[#assetStack]
end

function AssetManager.pushAssets()

	table.insert(assetStack, setmetatable({}, currentFrame()))

	print("Pushed Assets: " .. #assetStack)
end

function AssetManager.popAssets()

	if (#assetStack == 0) then
		error("Asset stack underflow")
	else
		for path, assetInfo in pairs(table.remove(assetStack)) do
			handlers[assetInfo.assetType].unload(assetInfo.asset)
		end
	end

	print("Popped Assets: " .. #assetStack)
end

function AssetManager.getAsset(path, assetType)
	local assetInfo = nil --currentFrame()[path] --HACK: Don't look up, just load everything
	if (assetInfo) then
		if (assetInfo.assetType == assetType) then
			print("Referencing loaded asset: " .. path);
			return assetInfo.asset
		else
			error("Asset at \"" .. path .. "\" is not of type \"" .. assetType .. "\"")
		end
	elseif (handlers[assetType]) then
		print("Loading unloaded asset:   " .. path);
		local asset = handlers[assetType].load(path)
		--currentFrame()[path] = { assetType = assetType, asset = asset}
		return asset
	else
		error("Unknown asset type \"" .. assetType .. "\"")
	end
end

return AssetManager

