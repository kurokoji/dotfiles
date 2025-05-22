local M = {}

--- 指定ディレクトリ直下のサブディレクトリから最新バージョンを返す
---@param parent string
---@return string|nil
function M.get_latest_version_dir(parent)
	-- 1. サブディレクトリ一覧を取得
	local raw = vim.fn.globpath(parent, "*", false, true)
	local items = {}

	for _, path in ipairs(raw) do
		-- 2. ディレクトリ名だけ取り出し
		local name = vim.fn.fnamemodify(path, ":t"):gsub("/$", "")
		-- 3. セマンティックバージョンとしてパース
		local ok, ver = pcall(vim.version.parse, name)
		if ok and ver then
			table.insert(items, { dir = path, ver = ver })
		end
	end

	-- 4. バージョン比較でソート
	table.sort(items, function(a, b)
		return vim.version.lt(a.ver, b.ver)
	end)


	-- 5. 最新があれば返却
	if #items > 0 then
		return items[#items].dir
	end
	return nil
end

return M
