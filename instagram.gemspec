# -*- encoding: utf-8 -*-
require File.expand_path('../lib/instagram/version', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency('rake', '~> 0.9.2.2')
  s.add_development_dependency('rspec', '~> 2.4')
  s.add_development_dependency('webmock', '~> 1.6')
  s.add_development_dependency('bluecloth', '~> 2.2.0')
  s.add_runtime_dependency('faraday', '>= 0.7')
  s.add_runtime_dependency('faraday_middleware', '>= 0.8')
  s.add_runtime_dependency('multi_json', '>= 1.0.3', '~> 1.0')
  s.add_runtime_dependency('hashie',  '>= 0.4.0')
  s.authors = ["Shayne Sweeney"]
  s.description = %q{A Ruby wrapper for the Instagram REST and Search APIs}
  s.post_install_message =<<eos
********************************************************************************

Instagram REST and Search APIs
------------------------------
Our developer site documents all the Instagram REST and Search APIs.
(http://instagram.com/developer)

Blog
----------------------------
The Developer Blog features news and important announcements about the Instagram Platform.
You will also find tutorials and best practices to help you build great platform integrations.
Make sure to subscribe to the RSS feed so you don't miss out on new posts:
(http://developers.instagram.com).

Community
----------------------
The Stack Overflow community is a great place to ask API related questions or if you need help with your code.
Make sure to tag your questions with the Instagram tag to get fast answers from other fellow developers and members of the Instagram team.
(http://stackoverflow.com/questions/tagged/instagram/)

********************************************************************************
eos
  s.email = ['shayne@instagr.am']
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/Instagram/instagram-ruby-gem'
  s.name = 'instagram'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = s.name
  s.summary = %q{Ruby wrapper for the Instagram API}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Instagram::VERSION.dup
end
