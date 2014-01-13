module Eff
  class Package
    class SemanticVersion
      PARTS = %i(major minor patch release identity)

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

    private
      def parse!
        remaining, @identity   = @version_string.split("+")
        remaining, @release    = remaining.split("-")
        @major, @minor, @patch = remaining.split(".")
      end
    end
  end
end
