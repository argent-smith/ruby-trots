require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Thor::Group#class_option" do

  before :all do
  end

  it "should set the option for a group" do
    module App
      class Zoo < Thor::Group
        class_option :who,
          :type => :string,
          :aliases => "-w",
          :default => "zebra"
        def animal
          options[:who]
        end
      end

      class Boss < Thor
        register Zoo, :zoo, "zoo", "something"

        default_task :zoo
      end
    end

    App::Boss.start([nil]).should               == ["zebra"]
    App::Boss.start(["--who", "quagga"]).should == ["quagga"]
    App::Boss.start(["-w", "elephant"]).should  == ["elephant"]
  end
end
