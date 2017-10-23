Project.LevelManager = Appkit.class(Project.LevelManager)
local LevelManager = Project.LevelManager -- cache off for readability and speed

LevelManager.level = 1

--一回ずれるまでのフレーム数
LevelManager.fallFrame = 1
-- 一回ずれる距離
LevelManager.fallDistance = 20

-- 接着時間
LevelManager.glueFrame = 80

-- 固定時間後次のブロックが出るまでのフレーム
LevelManager.nextWait = 30
-- 上のやつからラインが削除されたときのフレーム（演出時間を含めるということ）
LevelManager.nextWaitWithRemove = 30

--入力による落下を行ったか
local isInputFall = false
local fallCountFrame = 0
local glueFrame = 0

function LevelManager.countUpFallFrame()
    if isInputFall == false then
        fallCountFrame = fallCountFrame + 1
        glueFrame = 0

        if fallCountFrame >= LevelManager.fallFrame then
            fallCountFrame = 0
            return true
        else
            return false
        end
    else
        fallCountFrame = 0
        isInputFall = false
        glueFrame = 0
        return true
    end
end

function LevelManager.inputFall()
    isInputFall = true
end

function LevelManager.countUpGlueFrame()
    glueFrame = glueFrame + 1

    if glueFrame >= LevelManager.glueFrame then
        glueFrame = 0
        return true
    else
        return false
    end
end

function LevelManager.countUpLevel()
    fallCountFrame = 0
    glueFrame = 0
    isInputFall = false

    LevelManager.level = LevelManager.level + 1

    --何かすぷれっどシート化ＪＳＯＮ呼んで管理したい
end

local waitNextPopFrame = 0
local waitFrame = 0
function LevelManager.setWaitFrame(deleted)
    if deleted then
        waitNextPopFrame = LevelManager.nextWait
    else
        waitNextPopFrame = LevelManager.nextWaitWithRemove
    end
    waitFrame = 0
end

function LevelManager.countupWaitFrame()
    waitFrame = waitFrame + 1
    if waitNextPopFrame < waitFrame then
        return true
    else
        return false
    end
end

return LevelManager
