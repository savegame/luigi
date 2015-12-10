return { id = 'mainWindow',
    { type = 'menu',
        { text = 'File',
            { text = 'Save', id = 'menuSave', key = 'ctrl-s',
                status = 'Save to disk' },
            { text = 'Quit', id = 'menuQuit', key = 'escape',
                status = 'Quit the demo' },
        },
        { text = 'Edit',
            { text = 'Cut', key = 'ctrl-c' },
            { text = 'Copy', key = 'ctrl-x' },
            { text = 'Paste', key = 'ctrl-v' },
            { type = 'slider' },
        },
        { text = 'View',
            { text = 'Theme',
                { text = 'Light', key = 'ctrl-l', id = 'themeLight', },
                { text = 'Dark', key = 'ctrl-d', id = 'themeDark' },
            },
            { text = 'Style',
                { text = 'Default' },
            },
        },
        { text = 'Help',
            { id = 'about', text = 'About Luigi', icon = 'icon/16px/Book.png', key = 'f1', },
            { id = 'aboutDemo', text = 'About Luigi Demo', icon = 'icon/16px/Book Red.png', key = 'f2' },
            { id = 'license', text = 'License', key = 'f3'  },
        },
    },
    { style = 'toolbar',
        { id = 'newButton', style = 'toolButton', key = 'z',
            icon = 'icon/32px/Blueprint.png',
            status = 'Create a new thing' },
        { id = 'loadButton', style = 'toolButton',
            icon = 'icon/32px/Calendar.png',
            status = 'Load a thing' },
        { id = 'saveButton', style = 'toolButton',
            icon = 'icon/32px/Harddrive.png',
            status = 'Save a thing' },
    },
    { flow = 'x',
        { id = 'leftSideBox', minwidth = 200, width = 200, scroll = true, type = 'panel',
            { style = 'listThing', align = 'middle center',
                text = 'Try the scroll wheel on this area.' },
            { style = 'listThing', align = 'middle center',
                text = 'This text is centered, and in the middle vertically.' },
            { style = 'listThing', align = 'middle left',
                text = 'This text is aligned left, and in the middle vertically.' },
            { style = 'listThing', align = 'middle right',
                text = 'This text is aligned right, and in the middle vertically.' },
            { style = 'listThing', align = 'top center',
                text = 'This text is centered, and at the top vertically.' },
            { style = 'listThing', align = 'bottom center',
                text = 'This text is centered, and at the bottom vertically.' },
        },
        { type = 'sash' },
        { type = 'panel', id = 'mainCanvas' },
        { type = 'sash' },
        { type = 'panel', id = 'rightSideBox', minwidth = 200, width = 200, scroll = true,
            { id = 'flowTest', height = 'auto',  minheight = 128,
                {
                    { type = 'label', text = 'Slider' },
                    { type = 'slider', id = 'slidey', width = false },
                },
                {
                    { type = 'label', text = 'Stepper' },
                    { type = 'stepper', id = 'stepper', width = false, wrap = true,
                        { value = 1, text = 'Thing One' },
                        { value = 2, text = 'Thing Two' },
                        { value = 3, text = 'Thing Three' },
                        { value = 4, text = 'Thing Four' },
                    },
                },
                {
                    { type = 'label', text = 'Progress' },
                    { type = 'progress', id = 'progressBar', width = false },
                },
            },
            { height = 'auto',
                { type = 'label', text = 'Flow test' },
                { type = 'check', text = 'Vertical controls', id = 'flowToggle', },
                { type = 'label', text = 'Some radio widgets' },
                { type = 'radio', text = 'One fish' },
                { type = 'radio', text = 'Two fish' },
                { type = 'radio', text = 'Red fish' },
                { type = 'radio', text = 'Blue fish' },
            }
        },
    },
    { type = 'sash' },
    { type = 'panel', height = 'auto',
        { flow = 'x',
            { type = 'text', id = 'aTextField', text = 'Testing «ταБЬℓσ»: 1<2 & 4+1>3, now 20% off!' },
            { type = 'button', width = 90, id = 'aButton', text = 'Press me!' }
        },
        { type = 'status', id = 'statusbar' },
    },

}
