local M = {}

---@param fn function
---@return function(...): void
function M.async(fn)
    return function(...)
        local co = coroutine.create(fn)
        assert(type(co) == "thread", "failed to create coroutine")

        local function step(...)
            local ok, yielded = coroutine.resume(co, ...)
            if not ok then
                error(yielded)
            end

            if coroutine.status(co) == "dead" then
                return
            end

            assert(type(yielded) == "function", "async coroutine must yield a function")

            yielded(step)
        end

        step(...)
    end
end

---@generic T
---@param fn fun(resume: fun(result: T))
---@return T
function M.await(fn)
    assert(coroutine.running(), "await must be called inside a coroutine")
    return coroutine.yield(function(resume)
        assert(type(resume) == "function", "internal resume must be a function")
        fn(resume)
    end)
end

---@param tasks table
---@return any, table?
function M.all(tasks)
    local count = #tasks
    if count == 0 then
        return nil, {}
    end
    return M.await(function(resume)
        assert(type(resume) == "function", "internal resume must be a function")

        local remaining = count
        local results = {}
        local done = false

        for i, task in ipairs(tasks) do
            task(function(err, ...)
                if done then
                    return
                end

                if err ~= nil then
                    done = true
                    resume(err)
                    return
                end

                results[i] = ...
                remaining = remaining - 1

                if remaining == 0 then
                    done = true
                    resume(nil, results)
                end
            end)
        end
    end)
end

return M
