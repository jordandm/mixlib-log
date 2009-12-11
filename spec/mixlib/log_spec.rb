#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'tempfile'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe Mixlib::Log do

  # Since we are testing class behaviour for an instance variable
  # that gets set once, we need to reset it prior to each example [cb]
  before(:each) do
    Logit.instance_variable_set("@logger",nil)
  end
  
  it "should accept regular options to Logger.new via init" do
    tf = Tempfile.new("chef-test-log")
    tf.open
    lambda { Logit.init(STDOUT) }.should_not raise_error
    lambda { Logit.init(tf) }.should_not raise_error
  end
  
  it "should set the log level with :debug, :info, :warn, :error, or :fatal" do
    levels = {
      :debug => Logger::DEBUG,
      :info  => Logger::INFO,
      :warn  => Logger::WARN,
      :error => Logger::ERROR,
      :fatal => Logger::FATAL
    }
    levels.each do |symbol, constant|
      Logit.level = symbol
      Logit.logger.level.should == constant
    end
  end
  
  it "should raise an ArgumentError if you try and set the level to something strange" do
    lambda { Logit.level = :the_roots }.should raise_error(ArgumentError)
  end
  
  it "should pass other method calls directly to logger" do
    Logit.level = :debug
    Logit.should be_debug
    lambda { Logit.debug("Gimme some sugar!") }.should_not raise_error
  end
  
  it "should default to STDOUT if init is called with no arguments" do
    logger_mock = mock(Logger, :null_object => true)
    Logger.stub!(:new).and_return(logger_mock)
    Logger.should_receive(:new).with(STDOUT).and_return(logger_mock)
    Logit.init
  end
  
end
