module WorldCup
  class Event
    attr_accessor :id, :type, :player, :time

    def initialize(keys)
      @id = keys['id']
      @type = keys['type_of_event']
      @player = keys['player']
      @time = keys['time']
    end

    def to_s
      "##{@id}: #{@type}@#{time} - #{player}"
    end
  end
end
