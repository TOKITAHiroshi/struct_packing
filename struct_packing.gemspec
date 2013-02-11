# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "struct_packing"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["TOKITA Hiroshi"]
  s.date = "2013-02-11"
  s.description = "* Read/Write ruby object to byte array with C-like struct declarations."
  s.email = ["tokita.hiroshi@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/struct_packing.rb", "script/console", "script/console.cmd", "script/destroy", "script/destroy.cmd", "script/generate", "script/generate.cmd", "test/test_helper.rb", "test/test_struct_packing.rb", ".gemtest"]
  s.homepage = "http://github.com/TOKITAHiroshi/struct_packing"
  s.post_install_message = "PostInstall.txt"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "struct_packing"
  s.rubygems_version = "1.8.25"
  s.summary = "* Read/Write ruby object to byte array with C-like struct declarations."
  s.test_files = ["test/test_helper.rb", "test/test_struct_packing.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_development_dependency(%q<hoe>, ["~> 3.5"])
    else
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_dependency(%q<hoe>, ["~> 3.5"])
    end
  else
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<newgem>, [">= 1.5.3"])
    s.add_dependency(%q<hoe>, ["~> 3.5"])
  end
end
