require 'spec_helper'
require 'configurable'

class MyClass
  include Configurable

  default_configuration({
    :param_one => 1,
    :param_two => 2,
    :param_three => {
      :nested_param => 3
    }
  })

end

class NotConfigured
  include Configurable
end

describe Configurable do

  it "should allow nested config parameters" do
    MyClass.config.param_three.nested_param.should == 3
  end

  it "should have default configuration" do
    MyClass.config.param_one.should == 1
    MyClass.config.param_two.should == 2
  end

  it "should overwrite default configuration" do
    MyClass.configure do |config|
      config.param_one = 3
      config.param_two = 4
    end
    MyClass.config.param_one.should == 3
    MyClass.config.param_two.should == 4
  end

  it "should raise exception when configure with unexpected params" do
    lambda {
      MyClass.configure do |config|
        config.params_four = 10
      end
    }.should raise_error(Configurable::Errors::ConfigParamNotFound)
  end

  it "should raise exception when try to access config param which does not exist" do
    lambda { MyClass.config.param_four }.
      should raise_error(Configurable::Errors::ConfigParamNotFound)
  end

  it "should raise excpetion when default configuration does not exist" do
    lambda { NotConfigured.configure {|config| config.param_one = 1 } }.
      should raise_error(Configurable::Errors::NotConfigured)
  end

  it "should raise exception when class is not configured" do
    lambda { NotConfigured.config }.
      should raise_error(Configurable::Errors::NotConfigured)
  end

end
