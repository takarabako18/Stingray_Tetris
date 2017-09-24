local Unit = stingray.Unit
local World = stingray.World
local Level = stingray.Level
local Vector3 = stingray.Vector3
local SimpleProject = require "core/appkit/lua/simple_project"
BlockUnit = {}

blockUnit = {}

-- color_Block = {
--     stingray.Quaternion.from_elements(127, 255, 255, 255), -- T水色
--     stingray.Quaternion.from_elements(255, 0, 255, 255), -- S紫
--     stingray.Quaternion.from_elements(0, 255, 0, 255), -- Z緑
--     stingray.Quaternion.from_elements(0, 127, 255, 255), -- J青
--     stingray.Quaternion.from_elements(255, 127, 0, 255), -- Lオレンジ
--     stingray.Quaternion.from_elements(255, 255, 0, 255), -- O黄
--     stingray.Quaternion.from_elements(255, 0, 0, 255) -- I赤
-- }

-- color_Block = {
--     {127, 255, 255}, -- T水色
--     {255, 0, 255}, -- S紫
--     {0, 255, 0}, -- Z緑
--     {0, 127, 255}, -- J青
--     {255, 127, 0}, -- Lオレンジ
--     {255, 255, 0}, -- O黄
--     {255, 0, 0} -- I赤
-- }

color_Block = {
    {0, 1, 1}, -- T水色
    {1, 0, 1}, -- S紫
    {0, 1, 0}, -- Z緑
    {0, .5, 1}, -- J青
    {1, .5, 0}, -- Lオレンジ
    {1, 1, 0}, -- O黄
    {1, 0, 0} -- I赤
}


blockUnit.new = function()
    local obj = {}

    local unit
    local material
    local colorIndex = 0
    --local set_color = stingray.Material.set_vector4

    obj.Initialize = function(viewPosition)
        local world = SimpleProject.world
        unit = World.spawn_unit(world, "content/models/Blocks/SimpleBlock")
        Unit.set_local_position(unit, 1, viewPosition)
        Unit.set_unit_visibility(unit, false)

        -- メッシュ取得
        local mesh = Unit.mesh(unit, "pCube1")
        -- マテリアル取得
        material = stingray.Mesh.material(mesh, 1)

        -- color = stingray.Quaternion.from_elements(255, 127, 0, 255)
        -- stingray.Material.set_vector4(material, "base_color", color)
    end

    obj.SetVisible = function(index)
        Unit.set_unit_visibility(unit, true)
        if colorIndex ~= index then
            colorIndex = index
            --カラー変更
            c_data = color_Block[index]
            color = stingray.Quaternion.from_elements(c_data[1], c_data[2], c_data[3],255)
            stingray.Material.set_vector4(material, "base_color", color)
        end
    end

    obj.SetInvisible = function()
        Unit.set_unit_visibility(unit, false)
    end

    return obj
end

function BlockUnit.Create(position)
    --
    local b = blockUnit.new()
    b.Initialize(position)
    return b
end

return BlockUnit
