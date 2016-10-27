module Less
  module Rails
  end
end

require 'less'
require 'rails'
require 'tilt'
require 'sprockets'
begin
 require 'sprockets/railtie'
rescue LoadError
 require 'sprockets/rails/railtie'
end

require 'less/rails/version'
require 'less/rails/helpers'
require 'less/rails/less_processor'
require 'less/rails/import_processor'
require 'less/rails/less_template'
require 'less/rails/railtie'
