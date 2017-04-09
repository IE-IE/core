require 'pp'
require 'yaml'
require 'pathname'
require 'chunky_png'
require 'logger'

requires = [ 
  'helpers',
  'tables',

  'Block',
  'Format',
  'Progressbar',

  'Text/Text',
  'Text/Header',
  'Text/Entry',

  'Chitin/Chitin',
  'Chitin/Header',
  'Chitin/Biff',
  'Chitin/Resource',

  'Item/Item',
  'Item/Header',
  'Item/ExtendedHeader',
  'Item/Feature',

  'Library/Library',
  'Library/Biff/Biff',
  'Library/Biff/Header',
  'Library/Biff/Tileset',
  'Library/Biff/File',

  'Bam/Bam',
  'Bam/Cycle',
  'Bam/Frame',
  'Bam/Header'
]

requires.each { |path| require_relative path }

LOG = Logger.new(STDOUT)
LOG.level = Logger::WARN