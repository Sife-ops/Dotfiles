config.load_autoconfig()

c.content.user_stylesheets = ['~/.config/qutebrowser/css/solarized-dark-all-sites.css']
config.bind('<Ctrl-R>', 'config-cycle content.user_stylesheets "~/.config/qutebrowser/css/gruvbox-all-sites.css" "~/.config/qutebrowser/css/solarized-dark-all-sites.css" ""')
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('x', 'tab-close')
