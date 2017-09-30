require "core/appkit/lua/class"
require "core/appkit/lua/app"

local Unit = stingray.Unit
local World = stingray.World
local Level = stingray.Level
local Vector3 = stingray.Vector3
local SimpleProject = require "core/appkit/lua/simple_project"

Project.NextAndHold = Appkit.class(Project.NextAndHold)
local NextAndHold = Project.NextAndHold -- cache off for readability and speed

-- Nextとホールドブロックの管理
NextsModel = {}
NextsModel.new =
    function()
    local obj = {}

    -- 次のブロックを生成する
    obj.narabi = {1, 2, 3, 4, 5, 6, 7}
    obj.createBlock = function()
        local index = stingray.Math.random(1, table.maxn(obj.narabi))
        local blockIndex = obj.narabi[index]
        table.remove(obj.narabi, index)

        if table.maxn(obj.narabi) == 0 then
            obj.narabi = {1, 2, 3, 4, 5, 6, 7}
        end
        local script = require "script/lua/MainGame/Block"
        block = script.Init(blockIndex)
        return block
    end

    -- 変数
    obj.Nexts = {
        obj.createBlock(),
        obj.createBlock(),
        obj.createBlock()
    }

    obj.holdBlock = nil
    obj.canHold = true

    -- getter
    obj.getNexts = function(self)
        return obj.Nexts
    end
    obj.getHoldBlock = function(self)
        return obj.holdBlock
    end
    obj.getCanHold = function(self)
        return obj.canHold
    end

    --local function

    --function

    -- 通常のブロックの出力
    obj.pop = function(self)
        local b = obj.Nexts[1]
        table.remove(obj.Nexts, 1)
        table.insert(obj.Nexts, obj.createBlock())
        obj.canHold = true
        return b
    end

    -- ホールド
    obj.hold = function(self, fallenBlock)
        --落ちてた落ちてたブロックの回転情報リセット
        fallenBlock.resetRotate()
        if obj.holdBlock == nil then
            obj.holdBlock = fallenBlock
            block = obj.pop()
            obj.canHold = false
            return block
        else
            block = obj.holdBlock
            obj.holdBlock = fallenBlock
            obj.canHold = false
            return block
        end
    end

    -- イニシャルホールド
    obj.initalHold = function(self)
        if obj.holdBlock == nil then
            obj.holdBlock = obj.pop()
            local block = obj.pop()
            obj.canHold = false
            return block
        else
            local block = obj.holdBlock
            obj.holdBlock = obj.pop()
            obj.canHold = false
            return block
        end
    end
    return obj
end

-- Nネクスト表示とホールドブロック表示
NextView = {}
NextView.new = function()
    local obj = {}
    local world = SimpleProject.world

    -- ネクスト
    obj.nextView = {}
    local blockFactory = require "script/lua/MainGame/BlockUnit"

    for i = 1, 3 do
        local nextPlusX = -3 + i * 4
        local nextPlusZ = 25

        Next = {}
        for z = 1, 4 do
            RowView = nil or {}
            for x = 1, 4 do
                local view_position = Vector3(x + nextPlusX + i, 0, nextPlusZ - z)
                local unit = blockFactory.Create(view_position)
                table.insert(RowView, unit)
            end
            table.insert(Next, RowView)
        end
        table.insert(obj.nextView, Next)
    end

    -- ホールド
    obj.holdBlockView = {}
    local holdPlusX = -2
    local holdPlusZ = 25
    for z = 1, 4 do
        --VIewとモデルをわける
        RowView = nil or {}
        for x = 1, 4 do
            local view_position = Vector3(x + holdPlusX, 0, holdPlusZ - z)
            local unit = blockFactory.Create(view_position)
            table.insert(RowView, unit)
        end
        table.insert(obj.holdBlockView, RowView)
    end

    -- Viewの更新（）
    obj.updateView = function(self, model)
        -- NextのView更新

        for i = 1, 3 do
            local ba = model.Nexts[i]
            local block = model.getNexts()[i].block

            for z, var1 in ipairs(obj.nextView[i]) do
                -- ブロックの範囲を超えているか
                for x, var2 in ipairs(var1) do
                    
                    local num = block[z][x]
                    if num ~= 0 then
                        obj.nextView[i][z][x].SetVisible(num)
                    else
                        obj.nextView[i][z][x].SetInvisible()
                    end
                end
            end
        end

        -- HoldのView更新

        local hold = model.getHoldBlock()
        if hold == nil then
            --ホールドがない状態
            for z, var1 in ipairs(obj.holdBlockView) do
                for x, var2 in ipairs(var1) do
                    obj.holdBlockView[z][x].SetInvisible()
                end
            end
        else
            local holds = hold.block
            for z, var1 in ipairs(obj.holdBlockView) do
                for x, var2 in ipairs(var1) do
                    
                    local num = holds[z][x]
                    if num ~= 0 then
                        obj.holdBlockView[z][x].SetVisible(num)
                    else
                        obj.holdBlockView[z][x].SetInvisible()
                    end
                end
            end
        end
    end

    return obj
end

function NextAndHold.Start()
    --
    NextsModel = NextsModel.new()
    NextView = NextView.new()
    NextView.updateView(NextView, NextsModel)
end

function NextAndHold.pop()
    --

    local blockData = NextsModel.pop()
    NextView.updateView(NextView, NextsModel)
    return blockData
end

function NextAndHold.hold(fallenBlock)
    --
    local blockData = NextsModel.hold(NextsModel, fallenBlock)

    NextView.updateView(NextView, NextsModel)
    return blockData
end

function NextAndHold.initalHold()
    local blockData = NextsModel.initalHold()
    NextView.updateView(NextView, NextsModel)
    return blockData
end

function NextAndHold.getCanHold()
    return NextsModel.getCanHold()
end

return NextAndHold
