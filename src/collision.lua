local Collision = {}

Collision.collisionMasks = {}

function Collision.SetGroups(groups)
	for i, group in ipairs(groups) do
		Collision.collisionMasks[group] = i
	end
end

function Collision.GetMask(...)
	local mask = 0
	for i, group in ipairs(arg) do
		local groupMask = Collision.collisionMasks[group]
		assert(groupMask, "Bad collision group \"" .. tostring(group) .. "\"")
		mask = mask + Collision.collisionMasks[group]
	end

	return mask
end

function Collision.MakeFilter(ownCategory, collidableCategories)
	local category = Collision.GetMask(ownCategory)
	local mask = 0
	if (collidableCategories) then
		mask = Collision.GetMask(unpack(collidableCategories))
	else
		mask = Collision.GetMask()
	end
	return { categoryBits = category, maskBits = mask }
end

return Collision
