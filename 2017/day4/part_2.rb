module Day4
  class Part2
    def self.run(passphrases)
      Array(passphrases).map { |passphrase|
        validate(passphrase)
      }.count(true)
    end

    def self.validate(passphrase)
      words = passphrase.split(" ")
      permutations = words.map do |word|
        chars = word.split(//)
        if chars.uniq.count == 1
          word
        else
          chars.permutation.map { |permutation| permutation.join }.uniq
        end
      end.flatten
      permutations.count == permutations.uniq.count
    end
  end
end
