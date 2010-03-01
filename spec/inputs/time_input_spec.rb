# coding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe 'time input' do
  
  include FormtasticSpecHelper
  
  before do
    @output_buffer = ''
    mock_everything
    
    semantic_form_for(@new_post) do |builder|
      concat(builder.input(:publish_at, :as => :time))
    end
  end
   
  it_should_have_input_wrapper_with_class("time")
  it_should_have_input_wrapper_with_id("post_publish_at_input")
  it_should_have_a_nested_fieldset
  it_should_apply_error_logic_for_input_type(:time)

  it 'should have a legend and label with the label text inside the fieldset' do
    output_buffer.should have_tag('form li.time fieldset legend.label label', /Publish at/)
  end
  
  it 'should associate the legend label with the first select' do
    output_buffer.should have_tag('form li.time fieldset legend.label label[@for="post_publish_at_2i"]')
  end

  it 'should have an ordered list of two items inside the fieldset' do
    output_buffer.should have_tag('form li.time fieldset ol')
    output_buffer.should have_tag('form li.time fieldset ol li', :count => 2)
  end

  it 'should have five labels for hour and minute' do
    output_buffer.should have_tag('form li.time fieldset ol li label', :count => 2)
    output_buffer.should have_tag('form li.time fieldset ol li label', /hour/i)
    output_buffer.should have_tag('form li.time fieldset ol li label', /minute/i)
  end

  it 'should have two selects for hour and minute' do
    output_buffer.should have_tag('form li.time fieldset ol li', :count => 2)
  end
  
  describe ':selected option' do
    
    describe "when the object has a value" do
      it "should select the object value (ignoring :selected)" do
        output_buffer.replace ''
        @new_post.stub!(:created_at => Time.mktime(2012, 11, 30, 21, 45))
        with_deprecation_silenced do 
          semantic_form_for(@new_post) do |builder|
            concat(builder.input(:created_at, :as => :time, :selected => Time.mktime(1999, 12, 31, 22, 59)))
          end
        end
        output_buffer.should have_tag("form li ol li select#post_created_at_4i option[@selected]", :count => 1)
        output_buffer.should have_tag("form li ol li select#post_created_at_4i option[@value='21'][@selected]", :count => 1)
      end
    end
    
    describe 'when the object has no value' do
      it "should select the :selected if provided as a Time" do
        output_buffer.replace ''
        @new_post.stub!(:created_at => nil)
        with_deprecation_silenced do
          semantic_form_for(@new_post) do |builder|
            concat(builder.input(:created_at, :as => :time, :selected => Time.mktime(1999, 12, 31, 22, 59)))
          end
        end
        output_buffer.should have_tag("form li ol li select#post_created_at_4i option[@selected]", :count => 1)
        output_buffer.should have_tag("form li ol li select#post_created_at_4i option[@value='22'][@selected]", :count => 1)
      end
      
      it "should not select an option if the :selected is provided as nil" do
        output_buffer.replace ''
        @new_post.stub!(:created_at => nil)
        with_deprecation_silenced do 
          semantic_form_for(@new_post) do |builder|
            concat(builder.input(:created_at, :as => :time, :selected => nil))
          end
        end
        output_buffer.should_not have_tag("form li ol li select#post_created_at_4i option[@selected]")
      end
      
      it "should select Time.now if a :selected is not provided" do
        output_buffer.replace ''
        @new_post.stub!(:created_at => nil)
        semantic_form_for(@new_post) do |builder|
          concat(builder.input(:created_at, :as => :time))
        end
        output_buffer.should have_tag("form li ol li select#post_created_at_4i option[@selected]", :count => 1)
        output_buffer.should have_tag("form li ol li select#post_created_at_4i option[@value='#{Time.now.hour.to_s.rjust(2,'0')}'][@selected]", :count => 1)
      end
    end
    
  end
  
end
