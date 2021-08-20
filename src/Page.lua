local EntityRegistry = require(script.Parent.EntityRegistry)

local Page = {
	_initialized = false;
	_pages = {}
}

function Page.new(name, whitelist, blacklist)
	if Page._initialized == false then
		Page._init()
	end

	local page = {
		_whitelist = whitelist,
		_blacklist = blacklist,
		Name = name,
		Entities = {}
	}

	if whitelist then
		for entityId, e in pairs(EntityRegistry.GetEntities()) do
			local success = true

			for _, whitelistedComponent in pairs(whitelist) do
				if not e[whitelistedComponent] then
					success = false
					break
				end
			end

			if success == true then
				page.Entities[entityId] = e
			end
		end

		if blacklist then
			for entityId in pairs(page.entities) do
				local e = EntityRegistry.GetEntities()[entityId]

				for _, blacklistedComponent in pairs(blacklist) do
					if e[blacklistedComponent] then
						page.Entities[entityId] = nil
						break
					end
				end
			end
		end
	else
		for entityId, e in pairs(EntityRegistry.GetEntities()) do
			for _, blacklistedComponent in pairs(blacklist) do
				local success = true

				if e[blacklistedComponent] ~= nil then
					success = false
					break
				end

				if success == true then
					page.Entities[entityId] = e
				end
			end
		end
	end

	Page._pages[name] = page

	return page
end

function Page.EntityIsCompatible(pageData, e)
	if pageData._blacklist then
		for _, blacklistedComponent in ipairs(pageData._blacklist) do
			if e[blacklistedComponent] then
				return false
			end
		end
	end

	if pageData._whitelist then
		for _, whitelistedComponent in ipairs(pageData._whitelist) do
			if e[whitelistedComponent] ~= nil then
				return true
			end
		end
	end

	return true
end

function Page._init()
	Page._initialized = true
	EntityRegistry.OnEntityAdded:Connect(Page._onEntityAdded)
	EntityRegistry.OnEntityRemoved:Connect(Page._onEntityRemoved)
end

function Page._onEntityAdded(e)
	for _, pageData in pairs(Page._pages) do
		if Page.EntityIsCompatible(pageData, e) == true then
			pageData.Entities[e.EntityId] = e
		end
	end
end

function Page._onEntityRemoved(e)
	for _, pageData in pairs(Page._pages) do
		if pageData.Entities[e.EntityId] ~= nil then
			pageData.Entities[e.EntityId] = nil
		end
	end
end

return Page
