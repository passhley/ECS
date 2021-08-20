local RunService = game:GetService("RunService")

local lastOneHzUpdate = tick()
local alternatingUpdate = true

local Flow = {
	_initialized = false,
	_cache = {
		Heartbeat = {},
		PostSimulation = {},
		PreAnimation = {},
		PreRender = {},
		PreSimulation = {},
		Stepped = {},
		OneHz = {},
		AlternatingHz = {},
	}
}

function Flow.Add(type, f, p)
	if Flow._initialized == false then
		Flow._init()
	end

	local cache = Flow._cache[type]

	if type == nil then
		error("[Flow]: UpdateType is nil")
	elseif cache == nil then
		error("[Flow]: No UpdateType '" .. type .. "' found")
	elseif f == nil then
		error("[Flow]: No handler passed")
	end

	if p == nil then
		p = #cache + 1
	elseif cache[p] then
		error("[Flow]: Priority '" .. p .. "' for '" .. type .. "' is filled")
	end

	table.insert(cache, p, f)
end

function Flow.Remove(type, index)
	if Flow._initialized == false then
		Flow._init()
	end

	if not Flow._cache[type] then
		return error("[Flow]: No cache '" .. type .. "' found")
	end

	Flow._cache[type][index] = nil
end

function Flow._init()
	RunService.PostSimulation:Connect(function()
		for _,v in pairs(Flow._cache.PreSimulation) do
			v()
		end
	end)


	RunService.PreAnimation:Connect(function()
		for _,v in pairs(Flow._cache.PreAnimation) do
			v()
		end
	end)


	RunService.PreRender:Connect(function()
		for _,v in pairs(Flow._cache.PreRender) do
			v()
		end
	end)


	RunService.PreSimulation:Connect(function()
		for _,v in pairs(Flow._cache.PreSimulation) do
			v()
		end
	end)


	RunService.Stepped:Connect(function()
		for _,v in pairs(Flow._cache.Stepped) do
			v()
		end
	end)


	RunService.Heartbeat:Connect(function()
		for _,v in pairs(Flow._cache.Heartbeat) do
			v()
		end

		local now = tick()

		if now - lastOneHzUpdate > 1 then
			lastOneHzUpdate = now
			for _,v in pairs(Flow._cache.OneHz) do
				v()
			end
		end

		alternatingUpdate = not alternatingUpdate
		if alternatingUpdate then
			for _,v in pairs(Flow._cache.AlternatingHz) do
				v()
			end
		end
	end)
end

return Flow
