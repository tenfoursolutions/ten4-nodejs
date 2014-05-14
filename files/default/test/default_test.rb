require 'pry'
class TestingNodeJSInstallation < MiniTest::Chef::TestCase
  include MiniTest::Chef::Assertions
  def test_nodejs_installed
    assert_installed package('nodejs')
  end
  def test_nginx_enabled
    assert_enabled service('nginx')
  end
  def test_nginx_running
    assert_running service('nginx')
  end
  def test_default_site_not_enabled
    refute(FileTest.symlink? '/etc/nginx/sites-enabled/default')
  end
  def test_nodejs_nginx_conf_created
    assert(FileTest.exists? "/etc/nginx/sites-available/#{node['ten4-nodejs']['app']}")
  end
  def test_nodejs_nginx_conf_enabled
    assert(FileTest.symlink? "/etc/nginx/sites-enabled/#{node['ten4-nodejs']['app']}")
  end
  def test_project_is_checkedout
    assert(FileTest.directory? "#{node['ten4-nodejs'][:application_directory]}/.git")
  end
end
