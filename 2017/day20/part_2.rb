module Day20
  class Part2
    def self.run(particles)
      @particles = []
      
      particles.each_with_index do |particle, index|
        split = particle.split(', ')
        pdef = split[0]
        vdef = split[1]
        adef = split[2]
        
        pdef_split = pdef.match(/p=<(.*),(.*),(.*)>/).captures
        vdef_split = vdef.match(/v=<(.*),(.*),(.*)>/).captures
        adef_split = adef.match(/a=<(.*),(.*),(.*)>/).captures
        
        @particles << {
          index.to_s => {
            position: {
              x: pdef_split[0].to_i,
              y: pdef_split[1].to_i,
              z: pdef_split[2].to_i
            },
            velocity: {
              x: vdef_split[0].to_i,
              y: vdef_split[1].to_i,
              z: vdef_split[2].to_i
            },
            acceleration: {
              x: adef_split[0].to_i,
              y: adef_split[1].to_i,
              z: adef_split[2].to_i
            }
          }
        }
      end
      
      1000.times do
        step
        @particles = check
      end
      
      @particles.count
    end
    
    def self.check
      to_remove = []
      @particles.group_by do |particle|
        vals = particle.values
        pos = vals.first[:position]
      end.each { |key, vals|
        if vals.count > 1
          to_remove << vals.map(&:keys).flatten
        end
      }
      puts "to_remove = :#{to_remove}"
      @particles.reject { |k,v|
        to_remove.flatten.include?(k.keys.first)
      }
    end
    
    def self.step
      @particles.each_with_index do |particle_inf, index|
        particle = particle_inf.values.first
        particle[:velocity][:x] += particle[:acceleration][:x]
        particle[:velocity][:y] += particle[:acceleration][:y]
        particle[:velocity][:z] += particle[:acceleration][:z]
        
        particle[:position][:x] += particle[:velocity][:x]
        particle[:position][:y] += particle[:velocity][:y]
        particle[:position][:z] += particle[:velocity][:z]
      end
    end
  end
end
