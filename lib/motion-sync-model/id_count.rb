module SyncModel
  class IdCount < NanoStore::Model
    attribute :total

    def self.next
      ic = all.first || new
      total = ic.total || 0
      ic.total = total + 1
      ic.save
      ic.total
    end
  end
end
