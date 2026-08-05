return {
	"Maduki-tech/nvim-plantuml",
	ft = "plantuml",
	cmd = "PlantUML",
	config = function()
		require("plantuml").setup({
			output_dir = "/tmp",
			-- NOTE: viewer オプションは setup() 経由では反映されない（プラグイン側のバグ）。
			-- デフォルトの "open" (macOS) がそのまま使われる。
			auto_refresh = true,
		})
	end,
}
