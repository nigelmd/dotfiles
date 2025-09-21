return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 5000,
    },
    statuscolumn = {
      enabled = true,
    },
    words = { enabled = true },
    picker = {
      sources = {
        files = {
          hidden = true,
          -- ignored = true,
          exclude = {
            "**/.git/*",
          },
        },
        explorer = {
          hidden = true,
          -- ignored = true,
          exclude = {
            "**/.git/*",
          },
        },
      },
    },
    zen = {
      toggles = {
        dim = true,
      },
    },
    dashboard = {
      sections = {
        { section = "header" },
        {
          pane = 2,
          section = "terminal",
          cmd = "colorscript -e square",
          height = 5,
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              title = "Github notifications",
              cmd = "gh status",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "N",
              icon = " ",
              height = 5,
              enabled = true,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 7,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "P",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 7,
            },
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
    },
  },
}
