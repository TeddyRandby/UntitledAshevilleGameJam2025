require "util.table"

local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end

---@generic T: table, V
---@param t T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
function reversedipairs(t)
    return reversedipairsiter, t, #t + 1
end


function deep_print(tbl, indent, visited) --TODO Gross, for debug
  indent = indent or 0
  visited = visited or {}

  if visited[tbl] then
    print(string.rep("  ", indent) .. "*recursive reference*")
    return
  end
  visited[tbl] = true

  for k, v in pairs(tbl) do
    local keyStr = tostring(k)
    if type(v) == "table" then
      print(string.rep("  ", indent) .. keyStr .. " = {")
      deep_print(v, indent + 1, visited)
      print((string.rep("  ", indent) .. "}"))
    else
      print((string.rep("  ", indent) .. keyStr .. " = " .. tostring(v)))
    end
  end
end