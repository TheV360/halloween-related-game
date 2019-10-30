local Room = Object:extend()

Room.DefaultLayout = [[
	{
		"objects": [
			{
				"index": 0,
				"variant": 0,
				"pos": [0, 0]
			}
		]
]]

function Room:new(json)
	json = json or Room.DefaultLayout
	
	
end

function Room:update()
	
end
