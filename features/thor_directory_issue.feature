Feature: Suspected #directory issue
  In order to test #directory behavior
  As a Thor user
  I want to see whether it expands 'templated' filenames or not

  NB: this feature should be run with cucumber/aruba

  Background: making the test suite
    Given a file named "tester_wrong" with:
    """
    #!/usr/bin/env ruby

    require 'rubygems'
    require 'thor'

    class Tester < Thor
      include Thor::Actions

      def self.source_root
        File.expand_path('templates', File.dirname(__FILE__))
      end

      desc "test", "do the test"
      def test
        directory ".", "generated"
      end

      private                # This way is wrong
                             #
      def what_was_here      #
        "what_i_want_to_see" #
      end                    #
    end

    Tester.start
    """
    And a file named "tester_right" with:
    """
    #!/usr/bin/env ruby

    require 'rubygems'
    require 'thor'

    class Tester < Thor
      include Thor::Actions

      def self.source_root
        File.expand_path('templates', File.dirname(__FILE__))
      end

      desc "test", "do the test"
      def test
        directory ".", "generated"
      end

      no_tasks do               # This way is correct
        def what_was_here       #
          "what_i_want_to_see"  #
        end                     #
      end                       #
    end

    Tester.start
    """

    And an empty file named "templates/%what_was_here%.txt.tt"
    And an empty file named "templates/%what_was_here%_1.txt"
    And I run `chmod +x tester_right tester_wrong`

  Scenario: I expect it to create files with correct names
    When I run `./tester_wrong test`
    Then the following files should not exist:
      | generated/what_i_want_to_see.txt   |
      | generated/what_i_want_to_see_1.txt |
    And the following files should exist:
      | generated/%what_was_here%.txt.tt   |
      | generated/%what_was_here%_1.txt    |

  Scenario: I expect it to create files with correct names
    When I run `./tester_right test`
    Then the following files should exist:
      | generated/what_i_want_to_see.txt   |
      | generated/what_i_want_to_see_1.txt |

