-- Közös függvények, amelyek mind kliens, mind szerver oldalon működnek

-- Segédfüggvény annak ellenőrzésére, hogy egy érték létezik-e a táblában
function TableContains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Segédfüggvény tábla hosszának meghatározására (nem szekvenciális táblákkal is működik)
function TableLength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- Segédfüggvény két tábla egyesítésére
function MergeTables(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
    return t1
end

-- Segédfüggvény egy tábla mély klónozására
function DeepClone(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do
        res[k] = DeepClone(v)
    end
    return res
end

-- Segédfüggvény egy szám kerekítésére
function Round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10 ^ numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function RandomString(length)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = ''
    
    math.randomseed(os.time())
    
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. string.sub(chars, rand, rand)
    end
    
    return result
end

function StartsWith(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

function EndsWith(str, ending)
    return ending == '' or string.sub(str, -string.len(ending)) == ending
end

function SplitString(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch('(.-)' .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function ToBoolean(str)
    if str == nil then return false end
    str = tostring(str):lower()
    return str == 'true' or str == '1' or str == 'yes' or str == 'y'
end

function IsValidEmail(email)
    if not email then return false end
    return string.match(email, '^[%w%.%%%+%-]+@[%w%.%%%+%-]+%.%w+$') ~= nil
end

function HasDependency(resourceName)
    return GetResourceState(resourceName) == 'started'
end

function Debug(message)
    if Config.ExampleConfig.DebugMode then
        print('[DEBUG] ' .. message)
    end
end

function GetDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end
