return function()
	local sequence = {}

	local function AddLevel(data)
		table.insert(sequence, data)
	end



	AddLevel{file = "levels.level2", title = "nobody expects the soft pillow",
--		titleImage = "art/titles/tutorial_01.png"}
		titleImage = "art/titles/nobody expects the soft pillow.png"}		

	AddLevel{file = "levels.level3", title = "Out of the Frying Pan into the",
		titleImage = "art/titles/tutorial_01.png"}
--		titleImage = "art/titles/out of the frying pan and into the.png"}		

--	AddLevel{file = "levels.level4", title = "into the corn husk4",
--		titleImage = "art/titles/tutorial_01.png"}

	AddLevel{file = "levels.level5", title = "corny poper5",
		titleImage = "art/titles/tutorial_01.png"}

	AddLevel{file = "levels.level1", title = "When Pigs Fly",
		titleImage = "art/titles/tutorial_01.png"}
--		titleImage = "art/titles/when pigs fly.png"}	
		
	AddLevel{file = "levels.level6", title = "corny poper6",
		titleImage = "art/titles/tutorial_01.png"}

	AddLevel{file = "levels.level7", title = "tomato7",
		titleImage = "art/titles/tutorial_01.png"}
	
	AddLevel{file = "levels.level8", title = "tomato8",
		titleImage = "art/titles/tutorial_01.png"}	


--Don't add anything after this line or it won't work!
	return sequence
end
