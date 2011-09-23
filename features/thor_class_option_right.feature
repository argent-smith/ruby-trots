Feature: Thor::Group#class_option understands one-letter alias
  In order to fix my understanding of #class_option parsing rules 
  As a stupid hacker
  I want to test a thor standalone app 
  using Thor::Group class with class_option being set

  Note: You should use 'cucumber' and 'aruba' gems to run this feature
  Also add "require 'aruba/cucumber'" line to your 'features/support/env.rb'


  Background: One-letter option alias
    Given a file named "example.rb" with:
      """ruby
      #!/usr/bin/env ruby

      require 'thor'
      require 'thor/group'

      module App
        class Zoo < Thor::Group
          class_option :who,
            :type => :string,
            :aliases => "-w",
            :default => "zebra"
          def animal
            p options[:who]
          end
        end

        class Boss < Thor
          register Zoo, :zoo, "zoo", "something"

          default_task :zoo
        end
      end

      App::Boss.start
      """
      And I run `chmod +x example.rb`

  @wip
  Scenario: Simple stupid example just runs
    When I run `./example.rb`
    Then the exit status should be 0

  @wip
  Scenario Outline: Simple stupid example shows help
    When I run `./example.rb <option>`
    Then the output should contain:
    """
    example.rb zoo          # something
    """

    Examples:
      | option |
      | -h     |
      | --help |
      | help   |

  @wip
  Scenario Outline: it runs zoo task with different options
    When I run `./example.rb zoo <option> <value>`
    Then the output should contain:
    """
    "<word>"
    """

    Examples:
      | option | value | word  |
      |        |       | zebra |
      | --who  |       | zebra |
      | -w     |       | zebra |
      | --who  | wolf  | wolf  |
      | -w     | wolf  | wolf  |

