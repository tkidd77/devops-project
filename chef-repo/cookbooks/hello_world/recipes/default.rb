# Install IIS and define default site content

include_recipe 'iis::default'
include_recipe 'chef-client::default'

file 'C:\inetpub\wwwroot\iisstart.htm' do
  content '<html>
<head>
<title>Hello World</title>
</head>
<body>
<h1>Hello World!</h1>
</body>
</html>'
end

remote_file 'c:\\users\\administrator\\desktop\\CPU+Burn-in.exe' do
	source 'https://s3.amazonaws.com/tkidd-util/CPU+Burn-in.exe'
	action :create
end
