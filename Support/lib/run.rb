#!/usr/bin/env ruby -wKU

# 
#  Run
#  Processing.tmbundle
#  Build and run the sketch and create the output
#  
#  Created by Ted Broberg on 2013-01-07.

require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/tm/process'
require ENV['TM_BUNDLE_SUPPORT'] + '/lib/output'
require ENV['TM_SUPPORT_PATH'] + '/lib/web_preview'
require 'fileutils'

class Run

  @project_path = nil
  @bundle_support = nil
  @folder_name = nil
  
  def initialize
    
    @bundle_support = ENV['TM_BUNDLE_SUPPORT']
    file_path = ENV['TM_FILEPATH']
    
    if file_path
      @project_path = ENV['TM_PROJECT_DIRECTORY']
      @folder_name = File.basename @project_path
    else
      @project_path = "/tmp/textmate-processing/TmpClass"
      ENV['TM_PROJECT_DIRECTORY'] = @project_path
      FileUtils.mkdir_p @project_path unless File.directory? @project_path
      @folder_name = File.basename @project_path
      f = File.open("#{@project_path}/#{@folder_name}.pde", 'w')
      f.write STDIN.read
      f.close
    end
  end

  def buildSketch(extra_arg = "")
    
    start_time = Time.now
    cmd = "processing-java --run --force --sketch=#{@project_path} --output=#{@project_path}/build" + extra_arg
    
    TextMate.require_cmd("processing-java")
    init_html(cmd)
    STDOUT.sync = true
    
    output = Output.new
    
    TextMate::Process.run(cmd) do |str|
      STDOUT << output.print_line(str) + force_refresh
    end
    
    end_time = Time.now
    puts "Sketch did end at #{end_time} and did run for a total of #{end_time - start_time} seconds."
    puts "</div>#{force_refresh}"
    TextMate.exit_discard
  end
  
  # Force scroll update to html output as this for some reason does not work (autoScroll prop anywhere?)
  def force_refresh
    refresh_html = ""
    refresh_html << "<script type='text/javascript' charset='utf-8'>
      var element = document.getElementById('outputContent');
      document.body.scrollTop = element.offsetHeight;
    </script>"
    refresh_html
  end
  
  # Print initial html header.
  def init_html(cmd)
    
    puts "<link rel='stylesheet' href='file://#{e_url(@bundle_support)}/css/output.css' type='text/css' charset='utf-8' media='screen'>"
    puts "<script src='file://#{e_url(@bundle_support)}/js/output.js' type='text/javascript' charset='utf-8'></script>"
    print "<div id='top'>
    <div id='title'>Running sketch: #{@folder_name} &nbsp;</div><div id='subtitle'>#{@project_path}</div></div>"
    puts "<div id='outputContent'>"
      
  end
end

# if __FILE__ == $0
#     
# end
