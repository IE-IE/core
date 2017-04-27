class Text < Format
  attr_reader :header,
              :entries

  @@cache = {
    location: nil,
    header: nil,
    entries: nil,
  }

  def initialize( location, lazyload: false )
    LOG.info "\n"
    LOG.info "==============================="
    LOG.info "Analyzing dialog file..."

    if( @@cache[:location] == location )
      LOG.info "Using cache."
      use_cache
      yield 100 # as progress for loading text
    else
      @location = location
      @bytes = File.get_bytes( @location )

      @header = recreate(
        klass: Text::Header,
        one: true,
        bytes: @bytes
      )
      if lazyload
      	@lazyload = true
      	yield 100
      else
      	@entries = recreate_entries { |progress| yield progress }
      end

      save_cache
    end

    LOG.info "Analyzing dialog file finished."
    LOG.info "==============================="
  end

  def get_entry( id )
  	if @entries[id]
  		@entries[id]
  	elsif @lazyload
  		@entries[id] = create_entry( id )
  	else
  		nil
  	end
  end

  private

  def recreate_entries
    LOG.info "- recreating entries..."

    entries = []
    @progressbar = Progressbar.new( @header[:entries_count], display: false )

    @header[:entries_count].times do |i|
      entries << create_entry(i)
      yield @progressbar.tick
    end

    LOG.info " finished."

    entries
  end

  def create_entry( id )
    starting_offset = 18
    entry_size = 26
    offset = id * entry_size + starting_offset

    Text::Entry.new( @bytes, offset, @header[:string_offset], id )
  end

  def use_cache
    @location = @@cache[:location]
    @header = @@cache[:header]
    @entries = @@cache[:entries]
  end

  def save_cache
    @@cache = {}
    @@cache[:location] = @location
    @@cache[:header] = @header
    @@cache[:entries] = @entries
  end
end