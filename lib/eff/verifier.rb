module Eff
  class Verifier
    class << self
      def check(file, checksum, algo = Digest::SHA1)
        file_digest = algo.file(File.expand_path(file)).hexdigest
        file_digest == checksum
      end
    end
  end
end
