#!/usr/bin/env ruby
print_pid = ARGV[0]
list = IO.popen('launchctl list').readlines
running = list.inject([]) do |result, line|
  if line[/^[0-9]/]
    if print_pid
      result << line.sub(/\t0/, '')
    else
      result << line.sub(/\d+\t0\t/, '')
    end
  end
  result
end

header = "Process Name"
header[0,0] = "PID\t" if print_pid
running.unshift(header)

puts running
