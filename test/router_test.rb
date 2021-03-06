test 'Router'

puts "Waiting for web server"
sleep 1

pull

test 'welcome'

is @body.include?('Welcome to Assets'), true

test 'found, no md5'

pull '/assets/js/app.js'
is @code, 200

pull '/js/app.js'
is @code, 200

test 'not found, no md5'

pull '/assets/css/app.js'
is @code, 404

pull '/css/app.js'
is @code, 404

pull '/assets/css/404.js'
is @code, 404

pull '/assets/js/404.js'
is @code, 404

test 'found, md5'

pull '/assets/js/app-3e259351b6d47daf1d7c2567ce3914ab.js'
is @code, 200

test 'found, wrong md5'
pull '/assets/css/app-a1888dbd56e058ff1d827a261c12702b.css'
is @code, 200

