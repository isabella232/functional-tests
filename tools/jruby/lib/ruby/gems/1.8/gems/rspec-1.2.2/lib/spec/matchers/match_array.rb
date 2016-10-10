module Spec
  module Matchers

    class MatchArray #:nodoc:
      include Spec::Matchers::Pretty
      
      def initialize(expected)
        @expected = expected
      end

      def matches?(actual)
        @actual = actual        
        @extra_items = difference_between_arrays(@actual, @expected)
        @missing_items = difference_between_arrays(@expected, @actual)
        @extra_items.empty? & @missing_items.empty?
      end

      def failure_message_for_should
        message =  "expected collection contained:  #{@expected.sort.inspect}\n"
        message += "actual collection contained:    #{@actual.sort.inspect}\n"
        message += "the missing elements were:      #{@missing_items.sort.inspect}\n" unless @missing_items.empty?
        message += "the extra elements were:        #{@extra_items.sort.inspect}\n" unless @extra_items.empty?
        message
      end
      
      def failure_message_for_should_not
        "Matcher does not support should_not"
      end
      
      def description
        "contain exactly #{_pretty_print(@expected)}"
      end

      private

        def difference_between_arrays(array_1, array_2)
          difference = array_1.dup
          array_2.each do |element|
            if index = difference.index(element)
              difference.delete_at(index)
            end
          end
          difference
        end


    end

    # :call-seq:
    #   should =~ expected
    #
    # Passes if actual contains all of the expected regardless of order. 
    # This works for collections. Pass in multiple args  and it will only 
    # pass if all args are found in collection.
    #
    # NOTE: there is no should_not version of array.should =~ other_array
    # 
    # == Examples
    #
    #   [1,2,3].should   =~ [1,2,3]   # => would pass
    #   [1,2,3].should   =~ [2,3,1]   # => would pass
    #   [1,2,3,4].should =~ [1,2,3]   # => would fail
    #   [1,2,2,3].should =~ [1,2,3]   # => would fail
    #   [1,2,3].should   =~ [1,2,3,4] # => would fail
    OperatorMatcher.register(Array, '=~', Spec::Matchers::MatchArray)
  end
end
