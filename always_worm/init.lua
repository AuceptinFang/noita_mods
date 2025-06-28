-- Always Worm 模组
-- 让混沌变形只变成各种蠕虫

-- 设置polymorph表只包含各种蠕虫
function set_worm_only_polymorph()
	local worm_entities = {
        "data/entities/animals/worm.xml",           -- 普通蠕虫
		"data/entities/animals/worm_big.xml",       -- 大蠕虫
		"data/entities/animals/worm_tiny.xml",      -- 小蠕虫
		"data/entities/animals/worm_end.xml",       -- 地狱蠕虫
		"data/entities/animals/worm_skull.xml"      -- 幽灵蠕虫
	}
	
	PolymorphTableSet(worm_entities, false)
	PolymorphTableSet({}, true)
end

-- 模组初始化
function OnModPostInit()
	set_worm_only_polymorph()
end

-- 世界初始化时也设置一次
function OnWorldInitialized()
	set_worm_only_polymorph()
end

-- 每帧检查并确保polymorph表正确（仅在前100帧检查）
local frame_check_count = 0
function OnWorldPreUpdate()
	frame_check_count = frame_check_count + 1
	
	if frame_check_count <= 100 then
		local common_table = PolymorphTableGet(false)
		
		-- 检查表是否包含正确的蠕虫实体
		local expected_worms = {
			"data/entities/animals/worm.xml",
			"data/entities/animals/worm_big.xml",
			"data/entities/animals/worm_tiny.xml",
			"data/entities/animals/worm_end.xml",
			"data/entities/animals/worm_skull.xml"
		}
		
		local needs_reset = false
		if not common_table or #common_table ~= 5 then
			needs_reset = true
		else
			-- 检查是否包含所有预期的蠕虫
			for _, expected_worm in ipairs(expected_worms) do
				local found = false
				for _, actual_worm in ipairs(common_table) do
					if actual_worm == expected_worm then
						found = true
						break
					end
				end
				if not found then
					needs_reset = true
					break
				end
			end
		end
		
		if needs_reset then
			set_worm_only_polymorph()
		end
	end
end