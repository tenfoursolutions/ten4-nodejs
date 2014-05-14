application_name = "website_backend"
default['ten4-nodejs'][:app] = application_name
default['ten4-nodejs'][:user] = "root"
default['ten4-nodejs'][:port] = 5000
default['ten4-nodejs'][:server_name] = "ten4.ws"
default['ten4-nodejs'][:application_directory] = "/opt/ten4/#{application_name}"
default['ten4-nodejs'][:git_repository] = "git@github.com:tenfoursolutions/ten4backend.git"
