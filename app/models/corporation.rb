class Corporation
  attr_reader :name

  def self.all
    [
      Corporation.new("Cheung Shing Mars"),
      Corporation.new("Credicor"),
      Corporation.new("Ecoline"),
      Corporation.new("Helion"),
      Corporation.new("Mining Guild"),
      Corporation.new("Interplanetary Cinematics"),
      Corporation.new("Inventrix"),
      Corporation.new("Phobolog"),
      Corporation.new("Point Luna"),
      Corporation.new("Robinson Industries"),
      Corporation.new("Saturn Systems"),
      Corporation.new("Teractor"),
      Corporation.new("Tharsis Republic"),
      Corporation.new("Thorgate"),
      Corporation.new("United Nations Mars Initiative"),
      Corporation.new("Valley Trust"),
      Corporation.new("Vitor")
    ]
  end

  def initialize(name)
    @name = name
  end
end
