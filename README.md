# ECS
Lua ECS library

## Entities
An entity is a table containing a group of components, which can be anything.
To add an entity to the ECS you call
```lua
--@param entity: { ... any }
--@returns entityObject: { EntityId: string, ... any }
local entity = ECS.AddEntity(entity)
```

To remove the entity from the ECS you can call
```lua
ECS.RemoveEntity(entity.EntityId)
```

## Events
This ECS library provides a few event connections for knowing when Entities or Components
are added or removed.
```lua
ECS.OnEntityAdded:Connect(function(entity)
end)

ECS.OnEntityRemoved:Connect(function(entity)
end)

ECS.OnComponentAdded:Connect(function(entity, componentName, componentData)
end)

ECS.GetComponentAddedSignal(componentName):Connect(function(entity, componentData)
end)
```

## Pages
To create a new page you call
```lua
--@param pageName: string
--@param whitelist: { ... string } | nil
--@param blacklist: { ... string } | nil
--@returns page: { Entities: { [entityId]: Entity } }
local page = ECS.Page.new(pageName, whitelist, blacklist)
```
Pages store a group of entities based off your given blacklist and whitelist.
You can access a pages entities by calling ``page.Entities``
