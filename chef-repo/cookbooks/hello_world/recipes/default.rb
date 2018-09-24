# Install IIS and define default site content

include_recipe 'iis::default'
include_recipe 'chef-client::default'

# Throw down demo site

file 'C:\inetpub\wwwroot\iisstart.htm' do
  content '<html>
<head>
<title>Hello World</title>
</head>
<body>
<h1>Hello World!</h1>
<sub>EC2 instance: </sub>
</body>
</html>'
end

# Update site with 

powershell_script 'instance-id' do
  code <<-EOH
  $instanceId = Invoke-WebRequest -Uri http://169.254.169.254/latest/meta-data/instance-id
  (Get-Content C:\\inetpub\\wwwroot\\iisstart.htm).replace("EC2 instance: ", "EC2 instance: $instanceId") | Set-Content C:\\inetpub\\wwwroot\\iisstart.htm
  EOH
end

remote_file 'c:\\users\\administrator\\desktop\\CPU+Burn-in.exe' do
	source 'https://s3.amazonaws.com/tkidd-util/CPU+Burn-in.exe'
	action :create
end
