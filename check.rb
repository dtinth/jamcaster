require 'json'

PIDFILE = "/tmp/jamulus-icecaster-client.pid"
JAMULUS_COMMAND = "../jamulus/Jamulus --nogui -c 127.0.0.1 -i client.ini --clientname icecaster --mutemyown -j"

def main
  icecast_data = JSON.parse(`curl -s http://localhost:8000/status-json.xsl`)
  listeners = icecast_data['icestats']['source']['listeners']
  puts "@ #{Time.now}"
  jammers = File.read('../status.html').scan('<li>').size
  client_running = check_jamulus
  puts "=> Listeners: #{listeners}, Jammers: #{jammers}, Streamer active: #{client_running}"
  if listeners > 0 && jammers > 0 && !client_running
    command = "#{JAMULUS_COMMAND} & echo $! > #{PIDFILE}"
    puts "=> Starting Jamulus with command: #{command}"
    system command
    client_running = File.read(PIDFILE).to_i
    puts "=> Jamulus started with PID #{client_running}"
    sleep 1
    system "jack_connect 'Jamulus icecaster:output left' icecaster:input_1"
    system "jack_connect 'Jamulus icecaster:output right' icecaster:input_2"
  elsif client_running && jammers <= 1
    puts "=> Killing streamer"
    system "kill #{client_running}"
  end
  if client_running
    File.write('jamulus_name.txt', "listen    [#{listeners}]")
    system "kill -s SIGUSR1 #{client_running}"
  end
end

def check_jamulus
  return false unless File.exist?(PIDFILE)
  pid = File.read(PIDFILE).to_i
  return false unless File.exist?("/proc/#{pid}")
  exe = File.basename(File.realpath("/proc/#{pid}/exe"))
  return exe == 'Jamulus' ? pid : false
end

main
