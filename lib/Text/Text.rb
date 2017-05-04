class Text < Format
  attr_reader :header,
              :entries,
              :lazyload,
              :location,
              :bytes

  @@cache = {
    location: nil,
    header: nil,
    entries: nil,
  }

  def initialize( location, lazyload: false )
    LOG.info "\n"
    LOG.info "==============================="
    LOG.info "Analyzing dialog file..."

    @location = location
    @lazyload = lazyload

    if( @@cache[:location] == @location )
      LOG.info "Using cache."
      use_cache
      yield 100 # as progress for loading text
    else
      if @lazyload
      	# Download bytes only for header
      	@bytes = File.get_bytes( @location, offset: 0, number: 18 )
      else
      	@bytes = File.get_bytes( @location )
      end

      @header = recreate(
        klass: Text::Header,
        one: true,
        bytes: @bytes
      )

      if @lazyload
      	@entries = []
      	LOG.info "Using lazyload."
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
  	return if id >= @header[:entries_count]

  	if @entries[id]
  		@entries[id]
  	elsif @lazyload
  		@entries[id] = create_entry( id )
  		@entries[id]
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
    calculated_offset = id * entry_size + starting_offset

  	if @lazyload
      bytes = File.get_bytes( @location, offset: calculated_offset, number: entry_size )
    else
      offset = calculated_offset
    end

    Text::Entry.new( (bytes || @bytes), (offset || 0), id, self )
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