local util = require "src.util"

local Class = {}
Class.super = nil
Class.class = Class
Class.className = "Class"
Class._metatable = {__index = Class}

util.errorOnUndefinedProperty(Class)

local function isClass(object)
	return (type(object) == "table" and object.class == object)
end

local function isA(class, object)
	assert(isClass(class), "isA requires a valid class object as the first argument")
	if (not (type(object) == "table" and object.class)) then
		return false
	elseif (object.class == class) then
		return true
	else
		return isA(class, object.class.super)
	end
end

Class.makeMethod = function(class, func)
	assert(isClass(class), "makeMethod called with invalid class, did you forget to use a ':'?")
	assert(func and type(func) == "function", "makeMethod reqires a valid function as an argument")
	return function(self, ...)
		assert(isA(class, self), "Member function called with invalid self, did you forget to use a ':'?")
		return func(self, unpack(arg))
	end
end

Class.isAncestorOf = Class:makeMethod(function(class, object)
	assert(object, "isAncestorOf requires a non-nil object parameter")
	return isA(class, object)
end)

Class.isSubclassOf = Class:makeMethod(function(class, object)
	assert(object, "isSubclassOf requires a non-nil object parameter")
	return isA(object, class)
end)

Class._create = Class:makeMethod(function(class)
	local object = setmetatable({}, class._metatable)
	object.class = class
	return object
end)

Class.makeInit = Class:makeMethod(function(class, func)
	assert(func and type(func) == "function", "makeInit requires a valid function as an argument")

	class.initWith = class:makeMethod(function(localClass, object, ...)
		assert(object, "initWith must be called with a non-nil object parameter - did you forget to use ':'?")
		assert(isA(localClass, object), "initWith may only be called on instances of the calling class")
		return func(localClass, object, unpack(arg))
	end)

	class.init = class:makeMethod(function(localClass, ...)
		local object = localClass:_create();
		return localClass:initWith(object, unpack(arg))
	end)
end)

Class.makeSubclass = Class:makeMethod(function(class, name)
	assert(name, "makeSubclass: You must specify a name for the new subclass")
	local subclass = class:_create()
	subclass.super = subclass.class
	subclass.class = subclass
	subclass.className = name

	subclass._metatable = {}
	for name, func in pairs(class._metatable) do
		subclass._metatable[name] = func
	end
	subclass._metatable.__index = subclass

	subclass:makeInit(function(localClass, self)
		return localClass.class:initWith(self)
	end)

	print("Creating subclass: " .. class.className .. " -> " .. subclass.className)

	return subclass
end)

Class.setMeta = Class:makeMethod(function(class, name, value)
	assert(name ~= "index", "You may not set the __index metamethod with the setMeta function")
	class._metatable["__"..name] = value
end)

Class:makeInit(function(class, self)
	return self
end)

return Class
