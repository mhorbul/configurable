require 'spec_helper'
require 'configurable'

class MyClass
  include Configurable

  default_configuration({
    :param_one => 1,
    :param_two => 2
  })

end

class NotConfigured
  include Configurable
end

describe Configurable do

  it "should have default configuration" do
    MyClass.config[:param_one].should == 1
    MyClass.config[:param_two].should == 2
  end

  it "should overwrite default configuration" do
    MyClass.configure({
      :param_one => 3,
      :param_two => 4
    })
    MyClass.config[:param_one].should == 3
    MyClass.config[:param_two].should == 4
  end

  it "should raise exception when configure with unexpected params" do
    lambda {
      MyClass.configure({
        :params_four => 10
      })
    }.should raise_error(Configurable::Errors::ConfigParamNotFound)
  end

  it "should raise excpetion when default configuration does not exist" do
    lambda { NotConfigured.configure({}) }.
      should raise_error(Configurable::Errors::DefaultConfigNotExists)
  end

  it "should raise exception when class is not configured" do
    lambda { NotConfigured.config[:param_one] }.
      should raise_error(Configurable::Errors::NotConfigured)
  end

end
