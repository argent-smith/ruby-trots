require File.expand_path('../spec_helper', File.dirname(__FILE__))
require File.expand_path('../../lib/mkhotspot', File.dirname(__FILE__))

describe Mkhotspot do
  describe Config, "DSL"  do
    include UsesTempFiles
    context "doing direct subparsers invocation" do
      before :each do
        @config = Mkhotspot::Config.new :name => "hodzpod_01"
        @config.name.should == "hodzpod_01"
      end

      it "defines the BRAS construct" do
        @config.configure_bras "Cisco1" do
          ip       "10.0.0.1"
          login    "admin"
          password "foobar"
          enable   "zozozo"
        end
        @config.bras.name.should     == "Cisco1"
        @config.bras.ip.should       == "10.0.0.1"
        @config.bras.login.should    == "admin"
        @config.bras.password.should == "foobar"
        @config.bras.enable.should   == "zozozo"
      end

      it "defines the portal construct" do
        @config.configure_portal "Portal1" do
          v_server_name  "kewlportal.net"
          v_server_alias nil
          server_ip      "10.0.0.2"
          document_root  "/usr/work/www/kewlportal/html"
        end
        @config.portal.name.should            == "Portal1"
        @config.portal.v_server_name.should   == "kewlportal.net"
        @config.portal.v_server_alias.should  == nil
        @config.portal.server_ip.should       == "10.0.0.2"
        @config.portal.document_root.should   == "/usr/work/www/kewlportal/html"
      end
    end

    context "doing top-level parser invocation" do
      in_directory_with_file "test.cfg"

      # complex testers
      #
      def minimal_config_is_correct
        @config.name.should == "HS_01"
      end

      def bras_config_is_correct
        @config.bras.name.should              == "Cisco1"
        @config.bras.ip.should                == "10.0.0.1"
        @config.bras.login.should             == "admin"
        @config.bras.password.should          == "foobar"
        @config.bras.enable.should            == "zozozo"
      end

      def portal_config_is_correct
        @config.portal.name.should            == "Portal1"
        @config.portal.v_server_name.should   == "kewlportal.net"
        @config.portal.v_server_alias.should  == nil
        @config.portal.server_ip.should       == "10.0.0.2"
        @config.portal.document_root.should   == "/usr/work/www/kewlportal/html"
      end

      def full_config_is_correct
        minimal_config_is_correct and bras_config_is_correct and portal_config_is_correct
      end

      # spec per se
      #
      before :all do
        @config_text_minimal = %Q{
          hotspot "HS_01" do
          end
        }

        @config_text_full = %Q{
          # Toplevel hotspot configuration
          hotspot "HS_01" do

            # BRAS configuration
            configure_bras "Cisco1" do
              ip       "10.0.0.1"
              login    "admin"
              password "foobar"
              enable   "zozozo"
            end

            # Portal configuration
            configure_portal "Portal1" do
              v_server_name  "kewlportal.net"
              v_server_alias nil
              server_ip      "10.0.0.2"
              document_root  "/usr/work/www/kewlportal/html"
            end
          end
        }
      end

      it "defines a minimal hotspot from input string" do
        @config = Mkhotspot::Config.new :text => @config_text_minimal
        minimal_config_is_correct
      end

      it "defines full config from input string" do
        @config = Mkhotspot::Config.new :text => @config_text_full
        full_config_is_correct
      end


      it "defines a minimal config from a file" do
        content_for_file @config_text_minimal
        @config = Mkhotspot::Config.new :file => "test.cfg"
        minimal_config_is_correct
      end

      it "defines full config from a file" do
        content_for_file @config_text_full
        @config = Mkhotspot::Config.new :file => "test.cfg"
        full_config_is_correct
      end
      context "setting text, then file parsing priority" do
        it "prefers :text over :file if both are supplied" do
          content_for_file @config_text_full
          @config = Mkhotspot::Config.new :file => "test.cfg", :text => @config_text_minimal
          minimal_config_is_correct
          expect { full_config_is_correct }.to raise_error
        end
      end
    end
  end
end
