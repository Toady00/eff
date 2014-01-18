module Eff
  class Package
    class SemanticVersion
      include Comparable

      BASE_PARTS = %i(major minor patch)
      PARTS = BASE_PARTS + %i(release identity)

      PARTS.each do |part|
        attr_accessor part
      end

      def initialize(version_string)
        @version_string = version_string
        parse!
      end

      def to_h
        Hash[
          PARTS.map { |part| [part, send(part)] }
        ]
      end

      def <=>(other)
        result = 0
        BASE_PARTS.each do |part|
          result = self.public_send(part).to_i <=> other.public_send(part).to_i
          break unless result == 0
        end
        result
      end

    private
      def parse!
        remaining, @identity   = @version_string.split("+")
        remaining, @release    = remaining.split("-")
        @major, @minor, @patch = remaining.split(".")
      end
    end
  end
end
