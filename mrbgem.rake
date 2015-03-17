MRuby::Gem::Specification.new('mruby-trusterd-basicauth') do |spec|
  spec.license = 'MIT'
  spec.authors = 'qtkmz, trusterd organization'
  spec.version = '0.0.1'
  spec.summary = 'Basic Auth for Trusterd'
  spec.add_dependency 'mruby-crypt'
  spec.add_dependency 'mruby-io'
end
