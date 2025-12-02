local Promise = {}
Promise.__index = Promise

---@class Promise
---@field new fun(fn: fun(resolve: fun(...), reject: fun(err: any))) : Promise
---@field await fun(self: Promise): any
---@field all fun(...: Promise): Promise

---@return Promise
function Promise.new(fn)
    local self = setmetatable({}, Promise)

    self._done = false
    self._result = nil
    self._error = nil
    self._notify = function() end

    local resolve = function(...)
        if self._done then
            return
        end
        self._result = ...
        self._done = true
        self._notify()
    end

    local reject = function(err)
        if self._done then
            return
        end
        self._error = err
        self._done = true
        self._notify()
    end

    fn(resolve, reject)

    return self
end

function Promise:await()
    local co = coroutine.running()
    if not self._done then
        self._notify = function()
            coroutine.resume(co)
        end
        coroutine.yield(co)
    end

    assert(self._done)

    if self._error ~= nil then
        return error(self._error)
    end
    return self._result
end

---@param promises table<Promise>
---@return Promise
function Promise.all(promises)
    return Promise.new(function(resolve, reject)
        if #promises == 0 then
            resolve {}
            return
        end

        local collector = coroutine.create(function()
            local results = {}

            for i, p in ipairs(promises) do
                local ok, val = pcall(function()
                    return p:await()
                end)

                if not ok then
                    reject(val)
                    return
                end

                results[i] = val
            end

            resolve(results)
        end)

        local resumed_ok, resume_err = coroutine.resume(collector)
        if not resumed_ok then
            reject(resume_err)
        end
    end)
end

return Promise
