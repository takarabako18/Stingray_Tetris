Project.BlockClass = Appkit.class(Project.BlockClass)
local BlockClass = Project.BlockClass -- cache off for readability and speed

--ブロックの形状、色情報も含む
local shapes = {
    --T
    {
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 1, 1, 1},
            {0, 0, 1, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 1, 0},
            {0, 1, 1, 0},
            {0, 0, 1, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 1, 0},
            {0, 1, 1, 1}
        },
        {
            {0, 0, 0, 0},
            {0, 1, 0, 0},
            {0, 1, 1, 0},
            {0, 1, 0, 0}
        }
    },
    --S
    {
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 2, 2, 0},
            {0, 0, 2, 2}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 2, 0},
            {0, 2, 2, 0},
            {0, 2, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 2, 2, 0},
            {0, 0, 2, 2}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 2, 0},
            {0, 2, 2, 0},
            {0, 2, 0, 0}
        }
    },
    --Z
    {
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 3, 3},
            {0, 3, 3, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 3, 0, 0},
            {0, 3, 3, 0},
            {0, 0, 3, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 3, 3},
            {0, 3, 3, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 3, 0, 0},
            {0, 3, 3, 0},
            {0, 0, 3, 0}
        }
    },
    --J
    {
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 4, 0, 0},
            {0, 4, 4, 4}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 4, 0},
            {0, 0, 4, 0},
            {0, 4, 4, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {4, 4, 4, 0},
            {0, 0, 4, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 4, 4, 0},
            {0, 4, 0, 0},
            {0, 4, 0, 0}
        }
    },
    --L
    {
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 5, 0},
            {5, 5, 5, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 5, 0, 0},
            {0, 5, 0, 0},
            {0, 5, 5, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 5, 5, 5},
            {0, 5, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 5, 5, 0},
            {0, 0, 5, 0},
            {0, 0, 5, 0}
        }
    },
    --O
    {
        {
            {0, 0, 0, 0},
            {0, 6, 6, 0},
            {0, 6, 6, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 6, 6, 0},
            {0, 6, 6, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 6, 6, 0},
            {0, 6, 6, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 6, 6, 0},
            {0, 6, 6, 0},
            {0, 0, 0, 0}
        }
    },
    --I
    {
        {
            {0, 0, 0, 0},
            {7, 7, 7, 7},
            {0, 0, 0, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 7, 0},
            {0, 0, 7, 0},
            {0, 0, 7, 0},
            {0, 0, 7, 0}
        },
        {
            {0, 0, 0, 0},
            {7, 7, 7, 7},
            {0, 0, 0, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 7, 0},
            {0, 0, 7, 0},
            {0, 0, 7, 0},
            {0, 0, 7, 0}
        }
    }
}

blockclass = {}
blockclass.new = function(index)
    local Block = {}

    Block.blockIndex = index
    Block.block = shapes[Block.blockIndex][1]
    Block.rotate = 1

    Block.x = 4
    Block.z = 1

    -- ホールドしたときに回転情報をりせっとする
    Block.resetRotate = function(self)
        Block.rotate = 1
        Block.block = shapes[Block.blockIndex][1]
    end

    -- 時計まわりに回転
    Block.rotateclockWise = function(self)
        Block.rotate = Block.rotate - 1
        if Block.rotate == 0 then
            Block.rotate = 4
        end
        Block.block = shapes[Block.blockIndex][Block.rotate]
    end
    -- 時計回りに回転後のブロック情報を返す
    Block.getclockWiseShape = function(self)
        local r = Block.rotate - 1
        if r == 0 then
            r = 4
        end
        return shapes[Block.blockIndex][r]
    end

    -- 反時計まわりに回転
    Block.rotateReverse = function(self)
        Block.rotate = Block.rotate + 1
        if Block.rotate == 5 then
            Block.rotate = 1
        end
        Block.block = shapes[Block.blockIndex][Block.rotate]
    end

    -- 反時計回りに回転後のブロック情報を返す
    Block.getcReverseShape = function(self)
        local r = Block.rotate + 1
        if r == 5 then
            r = 1
        end
        return shapes[Block.blockIndex][r]
    end


    -- 現在のブロックと回転情報からブロックある一番上のラインを取得する
    -- 出現時の位置調整に必要
    local function getHight(self)
        line = 1
        isblock = false
        for z, var1 in ipairs(Block.block) do
            line = z
            for x, var2 in ipairs(var1) do

                if var2 ~= 0 then
                    isblock = true
                end
            end
            if isblock then
                break
            end
        end
        return line
    end

    Block.setInitialPosition = function(self)
        local block = Block.block
        local width = table.maxn(block[1])

        local xPos = 4
        local zPos = 1

        -- 上端のブロックをとって上に補正すべきだが
        local hight = getHight(self)
        zPos = zPos - hight + 1

        Block.x = xPos
        Block.z = zPos
    end
    

    -- 現在のブロックと回転情報からブロックある一番下のラインを取得
    -- 回転（一番下のラインを基準とする）に必要
    Block.getUnderLine = function(self)
        isBlock = false
        line = 0
        for z, var1 in ipairs(Block.block) do
            nothing = true
            for x, var2 in ipairs(var1) do
                if var1 ~= 0 then
                    nothing = false
                    isBlock = true
                end
            end

            if nothing and isBlock then
                -- 存在しなくなったラインの一つ上
                line = z - 1
                break
            end
        end

        -- 最後のライン
        if line == 0 then
            line = table.maxn(Block.block)
        end

        return line
    end

    Block.copyBlock = function(self)
        local script = require "script/lua/MainGame/Block"

        local copyblock = script.Init(Block.blockIndex)
        copyblock.rotate = Block.rotate
        copyblock.x = Block.x
        copyblock.z = Block.z
        copyblock.block = shapes[copyblock.blockIndex][copyblock.rotate]
        return copyblock
    end


    return Block
end

function BlockClass.Init(index)
    local b = blockclass.new(index)
    return b
end

return BlockClass
