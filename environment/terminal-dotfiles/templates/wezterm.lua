-- WezTerm 配置 - Kasugano 主题（自定义冷色调）
-- 作者: GTMI

local wezterm = require("wezterm")
local config = wezterm.config_builder()

------------------------
-- 配色方案: Kasugano --
------------------------
config.colors = {
    -- 基本色
    foreground = "#EDEDED",
    background = "#000000",

    -- 光标
    cursor_bg = "#EDEDED",
    cursor_fg = "#000000",
    cursor_border = "#EDEDED",

    -- 选中
    selection_fg = "#000000",
    selection_bg = "#6699CC",

    -- 滚动条
    scrollbar_thumb = "#334466",

    -- 分割线
    split = "#334466",

    -- Tab 栏
    tab_bar = {
        background = "#0A0A0A",

        active_tab = {
            bg_color = "#1A1A2E",
            fg_color = "#EDEDED",
            intensity = "Normal",
            italic = false,
            strikethrough = false,
        },

        inactive_tab = {
            bg_color = "#111111",
            fg_color = "#666666",
        },

        inactive_tab_hover = {
            bg_color = "#1A1A2E",
            fg_color = "#AAAAAA",
        },

        new_tab = {
            bg_color = "#0A0A0A",
            fg_color = "#6699CC",
        },

        new_tab_hover = {
            bg_color = "#1A1A2E",
            fg_color = "#88BBFF",
        },
    },

    -- ANSI 标准色（冷色调 · 蓝绿紫系）
    ansi = {
        "#000000", -- black
        "#CC5555", -- red（冷红）
        "#55CC88", -- green（青绿）
        "#C5A55A", -- yellow（冷金黄）
        "#5588CC", -- blue（冷蓝）
        "#AA77CC", -- magenta（紫）
        "#55BBCC", -- cyan（青）
        "#CCCCCC", -- white（浅灰）
    },

    -- ANSI 亮色
    brights = {
        "#555555", -- bright black
        "#FF7777", -- bright red
        "#77FFAA", -- bright green
        "#FFDD77", -- bright yellow
        "#77AAFF", -- bright blue
        "#CC99FF", -- bright magenta
        "#77DDEE", -- bright cyan
        "#FFFFFF", -- bright white
    },
}

------------------------
-- 字体配置 ------------
------------------------
config.font = wezterm.font_with_fallback({
    "Cascadia Code",
    "JetBrains Mono",
    "Fira Code",
    "Consolas",
})
config.font_size = 10.5

------------------------
-- 窗口配置 ------------
------------------------
-- 微透明度，透一点点看到桌面背景，但不会太杂乱
config.window_background_opacity = 0.75

config.macos_window_background_blur = 0

config.window_decorations = "TITLE | RESIZE"
config.window_close_confirmation = "NeverPrompt"

------------------------
-- Shell 配置（UTF-8） --
------------------------
-- 启动 PowerShell 时强制设置输入输出编码为 UTF-8，避免中文乱码
config.default_prog = {
    "powershell.exe", "-NoLogo", "-NoExit", "-Command",
    "[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new(); $OutputEncoding = [System.Text.UTF8Encoding]::new()"
}

config.set_environment_variables = {
    POWERSHELL_TELEMETRY_OPTOUT = "1",
}

------------------------
-- Tab 栏配置 ----------
------------------------
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_max_width = 25
config.switch_to_last_active_tab_when_closing_tab = true

------------------------
-- 其他 -----------------
------------------------
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 700
config.automatically_reload_config = true

return config
