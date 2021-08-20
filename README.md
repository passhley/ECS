# ECS
Lua ECS library

## Pages
To create a new page you call
```lua
--@param pageName: string
--@param whitelist: { ... string } | nil
--@param blacklist: { ... string } | nil
--@returns page: { Entities: { [entityId]: Entity } }
ECS.Page.new(pageName, whitelist, blacklist)
```
Pages store a group of entities based off your given blacklist and whitelist.
You can access a pages entities by calling ``page.Entities``
