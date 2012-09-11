def fixtures(path = nil)
  fixtures_path = File.join(File.dirname(__FILE__), '..', 'fixtures')
  path.nil? ? fixtures_path : File.join(fixtures_path, path)
end
