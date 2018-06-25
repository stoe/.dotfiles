module.exports = {
  config: {
    fontSize: 16,
    fontFamily: 'Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',
    cursorShape: 'BLOCK',
    cursorBlink: true,
    colors: {},
    windowSize: [1706, 1062],
    hyperlinks: {
      clickAction: 'open',
      defaultBrowser: true,
    },
    materialBox: {
      scheme: 'snazzy',
      autoHideTitle: true
    },
    hyperStatusLine: {
      footerTransparent: true,
    },
    hyperTabs: {
      trafficButtons: true,
      tabIconsColored: true,
    },
  },
  plugins: ['hyper-statusline', 'hyperlinks', 'hyper-pane', 'hypercwd', 'hyper-material-box', 'hyper-tabs-enhanced'],
  localPlugins: [],
};
