module SyncModel
  class NetworkQueue

    PRIORITIES = [:auth, :sync, :other]

    def setup_queue
      @queue = {}
      PRIORITIES.each { |key| @queue[key] = [] }
      @queue
    end

    def queue
      @queue || setup_queue
    end

    def add(proc, priority=:other)
      queue[priority] << proc
    end

    def running?
      @running == true
    end

    def execute
      return if running?
      @running = true
      #puts "QUEUE======== EXECUTING QUEUE #{verbose_count}"
      n = next_call
      n.execute if n.respond_to? :execute
    end

    def unlock_and_continue
      @running = false
      execute
    end

    def verbose_count
      PRIORITIES.map{|key| queue[key].count}.join(" ")
    end

    def count
      PRIORITIES.map{|key| queue[key].count}.inject(0, :+)
    end

    private

    def next_call
      PRIORITIES.each do |key|
        level_queue = queue[key]
        unless level_queue.empty?
          @pop = level_queue.delete_at(0)
          #puts "QUEUE======== executing #{key} #{@pop.class} #{@pop.to_s}"
          return @pop
        end
      end
      #puts "QUEUE======== END OF QUEUE"
      @running = false
      nil
    end
  end
end
