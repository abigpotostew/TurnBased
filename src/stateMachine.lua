local StateMachine = setmetatable({}, nil)

local smprint = function(...)
	if (arg ~= nil) then
	--	print(unpack(arg))
	end
end

function StateMachine.Create()
	local machine = setmetatable({}, {__index = StateMachine})

	machine.state = nil
	machine.functions = {}

	return machine
end

function StateMachine:GoToState(state)
	assert(state ~= nil and self.functions[state] ~= nil, "Bad target state for GoToState: " .. tostring(state))

	if (self.state == state) then
		smprint ("SM: Requested transition to current state: " .. self.state .. ", doing nothing")
		return true
	end

	if (self.state ~= nil) then
		smprint("SM: Attempting transition: " .. self.state .. " -> " .. state)
		local exitFunc = self.functions[self.state].exit
		if (exitFunc ~= nil and exitFunc() == false) then
			smprint("SM: Transition blocked by current state")
			return false
		end
	else
		smprint ("SM: Transition: nil -> " .. state)
	end

	self.state = state

	smprint("SM: State transition succeeded")

	-- Tail call, as states may reenter this function immediately
	smprint("SM: Calling enter function for new state")
	local enterFunc = self.functions[self.state].enter()

	return true
end

function StateMachine:SetState(name, functions)
	self.functions[name] = functions
end

function StateMachine:GetState()
	if (self.state == nil) then
		return nil, nil
	else
		return self.state, self.functions[self.state]
	end
end

return StateMachine
