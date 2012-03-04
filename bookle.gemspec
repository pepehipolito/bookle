Gem::Specification.new do |s|
  s.name        = 'bookle'
  s.version     = '0.0.0'
  s.date        = '2012-02-09'
  s.summary     = "Google Books API volume search."
  s.description = "Allows to search for books within Google Books. This is basically an adapter for the Google Books API for volume searches."
  s.authors     = ["Pepe Hipolito"]
  s.email       = 'pepe.hipolito@gmail.com'
  s.files       = Dir.glob("lib/bookle/google_*").collect {|f| "lib/bookle/#{File.basename(f)}"} << "lib/bookle.rb" << "lib/cacert/cacert.pem"
  s.homepage    = 'http://rubygems.org/gems/bookle'

  s.add_runtime_dependency 'json', '~> 1.1'
  s.add_runtime_dependency 'hasherizer', '~> 0.0'
end

# Need to install cacert.pem here, after the gem has been created.
