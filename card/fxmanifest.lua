fx_version 'cerulean'
games { 'gta5' }

lua54 'yes'

ui_page 'html/index.html'

files {
  'html/*.html',
  'html/*.jpg',
  'html/*.png',
  'html/js/*.js',
  'html/css/*.css',
  'html/img/*.jpg',
  'html/img/*.png',
}

client_scripts {
  'client/main.lua',
}

shared_script { 
	'@es_extended/imports.lua',
  '@ox_lib/init.lua',
  'config.lua',
  'functions.lua',
}

server_scripts {
  'server/main.lua',
}
