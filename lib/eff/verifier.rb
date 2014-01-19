module Eff
  class Verifier
    class << self
      def check(file, checksum, hash_function)
        return unless File.exists?(file)
        function    = function_const_get(hash_function)
        file_digest = function.file(file).hexdigest
        file_digest == checksum
      end

    private
      def function_const_get(value)
        hash_function = value.to_s.upcase
        Digest.const_get(hash_function)
      end
    end
  end
end
