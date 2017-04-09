require 'yaml'

TABLES = {}

Dir.glob(File.dirname(__FILE__) + '/tables/*.yml').each do |table|
  table = YAML.load_file(table)
  TABLES.merge!(table)
end

TABLES.freeze

LOG.debug "Tables generated and freezed."