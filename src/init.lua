local EntityRegistry = require(script.EntityRegistry)
local Page = require(script.Page)
local Flow = require(script.Flow)

return {
	-- Event Connections
	GetComponentAddedSignal = EntityRegistry.GetComponentAddedSignal,
	OnComponentAdded = EntityRegistry.OnComponentAdded,
	OnEntityAdded = EntityRegistry.OnEntityAdded,
	OnEntityRemoved = EntityRegistry.OnEntityRemoved,

	-- Entity Creation/Deletion
	AddEntity = EntityRegistry.AddEntity,
	RemoveEntity = EntityRegistry.RemoveEntity,

	-- Flow
	Flow = Flow,

	-- Component Organization
	Page = {
		new = Page.new
	}
}
