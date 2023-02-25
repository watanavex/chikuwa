# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerChikuwa do
    it "should be a plugin" do
      expect(Danger::DangerChikuwa.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.chikuwa
      end

      it "Errors on file not found" do
        @my_plugin.report "no file"
        expect(@dangerfile.status_report[:errors]).to eq(["build log file not found"])
      end

      it "Report" do
        file_path = "#{File.dirname(__FILE__)}/fixtures/build.log"
        @my_plugin.report file_path
        expect(@dangerfile.status_report[:warnings]).to eq(["Parameter 'context' is never used, could be renamed to _", "This is Kotlin 1.8 style message. Parameter 'context' is never used, could be renamed to _"])
        expect(@dangerfile.status_report[:errors]).to eq(["Unresolved reference: chikuwa", "This is Kotlin 1.8 style message. Unresolved reference: chikuwa"])
      end
    end
  end
end
