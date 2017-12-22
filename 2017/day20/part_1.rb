module Day20
  class Part1
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
      end
      
      @particles.map do |particle|
        vals = particle.values
        pos = vals.first[:position]
        { particle.keys.first => pos[:x].abs + pos[:y].abs + pos[:z].abs }
      end.sort_by { |hsh| hsh.values }.first.keys.first.to_i
    end
    
    def self.step
      @particles.each_with_index do |particle_inf, index|
        particle = particle_inf[index.to_s]
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
