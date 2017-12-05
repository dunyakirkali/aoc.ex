module Day4
  class Part1
    def self.run(passphrases)
      Array(passphrases).map { |passphrase|
        validate(passphrase)
      }.count(true)
    end

    def self.validate(passphrase)
      words = passphrase.split(" ")
      words.count == words.uniq.count
    end
  end
end
