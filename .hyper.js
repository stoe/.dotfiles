module.exports = {
  config: {
    shell: "/bin/zsh",
    fontSize: 16,
    fontFamily:
      "'FiraCode Nerd Font Mono', Menlo, 'DejaVu Sans Mono', 'Lucida Console', monospace",
    cursorShape: "BEAM",
    cursorBlink: false,
    colors: {},
    windowSize: [1706, 1062],
    hyperlinks: {
      clickAction: "open",
      defaultBrowser: true,
    },
    hyperStatusLine: {
      footerTransparent: true,
    },
    hyperTabs: {
      trafficButtons: true,
      tabIconsColored: true,
    },
  },
  plugins: [
    "hyperlinks",
    "hyper-nord",
    "hyper-pane",
    "hyper-tabs-enhanced",
    "hyper-statusline",
  ],
  localPlugins: [],
};
