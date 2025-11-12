local M = {}

--- テーブル t に値 v が含まれるか
---@param t any[]
---@param v any
---@return boolean
function M.contains(t, v)
  return vim.tbl_contains(t, v)
end

--- A ∪ B （和集合）
---@param A any[]
---@param B any[]
---@return any[]
function M.union(A, B)
  local res = vim.deepcopy(A)
  for _, v in ipairs(B) do
    if not vim.tbl_contains(res, v) then
      table.insert(res, v)
    end
  end
  return res
end

--- A ∩ B （積集合）
---@param A any[]
---@param B any[]
---@return any[]
function M.intersection(A, B)
  return vim.tbl_filter(function(v)
    return vim.tbl_contains(B, v)
  end, A)
end

--- A \ B （差集合）
---@param A any[]
---@param B any[]
---@return any[]
function M.difference(A, B)
  return vim.tbl_filter(function(v)
    return not vim.tbl_contains(B, v)
  end, A)
end

--- A △ B （対称差）
---@param A any[]
---@param B any[]
---@return any[]
function M.symmetric_difference(A, B)
  return M.union(M.difference(A, B), M.difference(B, A))
end

--- A ⊆ B （部分集合判定）
---@param A any[]
---@param B any[]
---@return boolean
function M.is_subset(A, B)
  for _, v in ipairs(A) do
    if not vim.tbl_contains(B, v) then
      return false
    end
  end
  return true
end

--- A == B （同値集合判定、順序は無視）
---@param A any[]
---@param B any[]
---@return boolean
function M.is_equal(A, B)
  if #A ~= #B then
    return false
  end
  return M.is_subset(A, B) and M.is_subset(B, A)
end

--- テーブルを集合として扱いやすいようキー→trueの map に変換
---@param t any[]
---@return table<any, boolean>
function M.to_set(t)
  local s = {}
  for _, v in ipairs(t) do s[v] = true end
  return s
end

--- map (キー→true) を配列に変換
---@param s table<any, boolean>
---@return any[]
function M.to_list(s)
  local t = {}
  for k in pairs(s) do table.insert(t, k) end
  return t
end

return M
