local HttpService = game:GetService("HttpService")

local Signal = require(script.Parent.Signal)

local EntityRegistry = {
	OnEntityAdded = Signal.new(),
	OnEntityRemoved = Signal.new(),
	OnComponentAdded = Signal.new(),
	ComponentAddedSignals = {},
	_entities = {}
}

function EntityRegistry.AddEntity(e)
	local entityId = HttpService:GenerateGUID(false)
	local data = {
		EntityId = entityId
	}

	if e then
		for i, v in pairs(e) do
			EntityRegistry._addComponentToEntity(data, i, v)
		end
	end

	EntityRegistry.OnEntityAdded:Fire(data)
	EntityRegistry._entities[entityId] = data

	return data
end

function EntityRegistry.RemoveEntity(entityId)
	if EntityRegistry._entities[entityId] then
		EntityRegistry.OnEntityRemoved:Fire(EntityRegistry._entities[entityId])
		EntityRegistry._entities[entityId] = nil
	end
end

function EntityRegistry.GetComponentAddedSignal(name)
	if EntityRegistry.ComponentAddedSignals[name] == nil then
		EntityRegistry.ComponentAddedSignals[name] = Signal.new()
	end

	return EntityRegistry.ComponentAddedSignals[name]
end

function EntityRegistry.GetEntities()
	return EntityRegistry._entities
end

function EntityRegistry._addComponentToEntity(e, name, data)
	if e[name] then
		return error("[EntityRegistry]: Attempted to add already existing component to entity.")
	end

	if EntityRegistry.ComponentAddedSignals[name] == nil then
		EntityRegistry.ComponentAddedSignals[name] = Signal.new()
	end

	e[name] = data
	EntityRegistry.OnComponentAdded:Fire(e, name, data)
	EntityRegistry.ComponentAddedSignals[name]:Fire(e, data)
end

return EntityRegistry
