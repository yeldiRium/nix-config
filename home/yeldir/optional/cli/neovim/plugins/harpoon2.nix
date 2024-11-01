{
  config,
  pkgs,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = harpoon2;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          local harpoon = require('harpoon')
          harpoon:setup({})

          -- basic telescope configuration
          local conf = require("telescope.config").values
          local function toggle_telescope(harpoon_files)
              local file_paths = {}
              for _, item in ipairs(harpoon_files.items) do
                  table.insert(file_paths, item.value)
              end

              require("telescope.pickers").new({}, {
                  prompt_title = "Harpoon",
                  finder = require("telescope.finders").new_table({
                      results = file_paths,
                  }),
                  previewer = conf.file_previewer({}),
                  sorter = conf.generic_sorter({}),
              }):find()
          end

          -- vim.keymap.set("n", "<leader>hh", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
        '';
    }
  ];

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      directories = [
        ".local/share/nvim/harpoon"
      ];
    };
  };
}
