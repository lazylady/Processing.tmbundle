# 
#  output.rb
#  Processing.tmbundle
#  
#  Formats Processing log to be used for Textmate HTML output
#  Created by Ted Broberg on 2013-01-08.
# 
class Output
  
  def initialize
    @line_count = 0;  
    @generic_error = /(^[^:]+).([0-9]+).([0-9|:]*).(.*)/
    
    # Custom user log types for some coloring of the log
    @log_error = /(#error)/
    @log_warn = /(#warning|#warn)/
    @log_fatal = /(#fatal)/
    @log_debug = /(#debug)/
  end
  
  def print_line(line)
    
    output = parse_line(line)
    output
  end
  
  def parse_line(line)
    
    @line_count = @line_count + 1
    project_path = ENV['TM_PROJECT_DIRECTORY']
    out = ""
    
    match = @generic_error.match(line)
    if match
      out << "<br/><div id='error'>"
      error = match[4]
      
      if error
        error = error.first.capitalize
      end
      
      out << error + ' <a title="Click to open ' + match[1] +
      '" href="txmt://open?url=file://' + project_path + "/" + match[1] + '&line=' + match[2] + '" >' + match[1] + '</a><br/>'
    else
      log_type = ""
      match = ""
      if match = @log_error.match(line)
        log_type = match[1]
      elsif match = @log_warn.match(line)
        log_type = match[1]
      elsif match = @log_fatal.match(line)
        log_type = match[1]
      elsif match = @log_debug.match(line)
        log_type = match[1]
      else
        log_type = "normal"
      end
      line.gsub!(log_type, "")
      log_type.gsub!("#", "")
      out << "<div id='outPutRow#{@line_count % 2}'>" << "<div id='log_#{log_type}'>" << line << "</div>"
    end
    out << "</div>"
    out
  end
end