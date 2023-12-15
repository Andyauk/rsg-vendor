fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'Kz#5669 and RexShack#3041'
description 'rsg-vendor'
version '1.0.3'

shared_scripts {
    '@ox_lib/init.lua',
    '@rsg-core/shared/locale.lua',
    'locale/en.lua',
    'config.lua'
}
client_scripts {
    'client/*.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
    'rsg-core',
    'rsg-menu',
    'rsg-input',
    'rsg-inventory',
    'ox_lib'
}

lua54 'yes'
