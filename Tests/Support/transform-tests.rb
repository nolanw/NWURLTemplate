#!/usr/bin/env ruby
require 'json'
require 'pathname'

TESTS_PATH = Pathname.new(__FILE__).dirname.parent.realpath
TESTS = {
  "spec-examples" => "TestExamples",
  "extended-tests" => "TestExtended",
  "negative-tests" => "TestNegative"
}

class String
  def indent(levels)
    gsub /^/,  ' ' * (levels * 4)
  end
  
  def unindent
    gsub /^#{self[/\A\s*/]}/, ''
  end
end

def header(class_name)
  <<-END.unindent
    // #{class_name}.m
    //
    // Public domain. https://github.com/nolanw/NWURLTemplate
  
    #import <XCTest/XCTest.h>
    #import "NWURLTemplate.h"
  
    @interface #{class_name} : XCTestCase
  
    @end
  
    @implementation #{class_name}
    
  END
end

def footer
  <<-END.unindent
    @end
    
  END
end

def methodize(name)
  name.gsub(/\s+|:/, '')
end

def joiner(indent)
  if indent > 0
    ",\n   #{' ' * indent}"
  else
    ", "
  end
end

def literalize(value, subsequent_line_indent=0)
  case value
  when Array
    "@[ " + value.map {|i| literalize(i)}.join(joiner(subsequent_line_indent)) + " ]"
  when Hash
    "@{ " + value.map {|k, v| "#{literalize k}: #{literalize v}"}.join(joiner(subsequent_line_indent)) + " }"
  when String, Numeric
    "@#{value.to_json}"
  else
    "null"
  end
end

TESTS.each do |json_basename, class_name|
  mfile = "#{class_name}.m"
  File.open(TESTS_PATH + mfile, 'w') do |m|
    json = JSON.parse(File.read(TESTS_PATH + "uritemplate-test" + "#{json_basename}.json"))
    m << header(class_name)
    
    json.each do |group_name, group|
      m << <<-END.unindent
        - (void)test#{methodize group_name}
        {
            id object = #{literalize group["variables"], 24};
            
      END
      
      group["testcases"].each do |test|
        m << <<-END.unindent.indent(1)
          {{
              NWURLTemplate *template = [[NWURLTemplate alloc] initWithString:#{literalize test.first}];
              NSURL *URL = [template URLWithObject:object];
        END
        
        expected = test.last
        case expected
        when String
          m << "XCTAssertEqualObjects(URL.absoluteString, #{literalize expected});\n".indent(2)
        when Array
          m << <<-END.unindent.indent(2)
            NSArray *possibilities = #{literalize expected, 37};
            XCTAssertTrue([possibilities containsObject:URL.absoluteString], @"didn't find %@", URL);
          END
        when false
          m << <<-END.unindent.indent(2)
            (void)URL;
            XCTAssertNotNil(template.error);
          END
        end
        
        m << "}}".indent(1)
        m << "\n"
      end
      
      m << "}\n\n"
    end
    
    m << footer
  end
end
