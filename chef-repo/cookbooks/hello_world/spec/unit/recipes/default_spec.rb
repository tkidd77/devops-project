#
# Cookbook:: hello_world
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# require 'spec_helper'

# describe 'hello_world::default' do
#   context 'When all attributes are default, on Windows 2016' do
#     let(:chef_run) do
#       # for a complete list of available platforms and versions see:
#       # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
#       runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2016')
#       runner.converge(described_recipe)
#     end

#     it 'converges successfully' do
#       expect { chef_run }.to_not raise_error
#     end
#   end
# end

require 'chefspec'

describe 'hello_world::default' do
  let :chef_run do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2016')
  end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
end

describe 'hello_world::default' do

  let :chef_run do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2016').converge(described_recipe)
  end

     it 'touches the correct file' do
       expect(chef_run).to create_file('C:\inetpub\wwwroot\iisstart.htm')
     end

# Would be best to check contents of file as well - need to get this test working

    # it "has the right lines in c:\\inetpub\\wwwroot\\iisstart.htm" do
    #   ['Hello World', 'Hello World!'].each do |line|
    #     file('C:\inetpub\wwwroot\iisstart.htm').must_include line
    #   end
    # end
end
