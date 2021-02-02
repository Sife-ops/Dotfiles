config.load_autoconfig()

import dracula.draw

# Load existing settings made via :set
config.load_autoconfig()

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    }
})

c.fonts.default_size = '16pt'
c.fonts.web.size.default = 20
c.fonts.web.size.default_fixed = 16

c.content.user_stylesheets = ['~/.config/qutebrowser/css/gruvbox-all-sites.css']
config.bind('<Ctrl-R>', 'config-cycle content.user_stylesheets "~/.config/qutebrowser/css/gruvbox-all-sites.css" "~/.config/qutebrowser/css/solarized-dark-all-sites.css" ""')

config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('d', 'scroll-page 0 0.5')
config.bind('u', 'scroll-page 0 -0.5')
config.bind('x', 'tab-close')
