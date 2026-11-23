--!strict
-- Stable IDs are shared with future catching, index, and persistence features.
local species = {
	{
		Id = "Chicken",
		DisplayName = "Angry Chicken",
		Rarity = "Common",
		Home = Vector3.new(-50, 1, -125),
	},
	{
		Id = "WaddleDuck",
		DisplayName = "Waddle Duckling",
		Rarity = "Common",
		Home = Vector3.new(-30, 1, -195),
	},
	{
		Id = "GrumpyBison",
		DisplayName = "Grumpy Bison",
		Rarity = "Rare",
		Home = Vector3.new(15, 1, -220),
	},
	{
		Id = "MoodyCow",
		DisplayName = "Moody Cow",
		Rarity = "Rare",
		Home = Vector3.new(-55, 1, -245),
	},
	{
		Id = "BouncyPig",
		DisplayName = "Bouncy Pig",
		Rarity = "Epic",
		Home = Vector3.new(35, 1, -125),
	},
	{
		Id = "WoolballSheep",
		DisplayName = "Woolball",
		Rarity = "Epic",
		Home = Vector3.new(-25, 1, -285),
	},
	{
		Id = "Scarecrow",
		DisplayName = "Living Scarecrow",
		Rarity = "Legendary",
		Home = Vector3.new(55, 1, -285),
	},
	{
		Id = "CornfedColossus",
		DisplayName = "Corn Colossus",
		Rarity = "Mythic",
		Home = Vector3.new(5, 1, -165),
	},
}
local byId = {}
for _, entry in species do
	byId[entry.Id] = table.freeze(entry)
end
return table.freeze({ Species = table.freeze(species), ById = table.freeze(byId) })
