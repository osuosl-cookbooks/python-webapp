if defined?(ChefSpec)
  def install_python_webapp(name)
    ChefSpec::Matchers::ResourceMatcher.new(:python_webapp, :install, name)
  end
end
