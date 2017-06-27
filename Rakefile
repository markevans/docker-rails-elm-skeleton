task :default do
  system "rake -T"
end

DC_PROD = "docker-compose -f docker-compose.prod.yml"

desc "deploy to current docker machine"
task :deploy => [
    "deploy:set_machine",
    "deploy:stop",
    "deploy:build",
    "deploy:assets",
    "deploy:up"
  ] do
end

namespace :deploy do

  def dprod(args)
    system "#{DC_PROD} #{args}"
  end

  def set_docker_env(machine_name)
    env_commands = `docker-machine env #{machine_name} --shell=cmd`.split("\n")
    env_commands.each do |cmd|
      md = cmd.match(/\ASET (.*)=(.*)\Z/)
      ENV[md[1]] = md[2] if md
    end
  end

  desc "point docker to the correct machine"
  task :set_machine do
    machines = `docker-machine ls -q`.split("\n")
    case machines.size
    when 0
      puts "There are no docker machines to deploy to"
      next
    when 1
      machine_name = machines.first
    else
      puts "Which machine amigo?"
      machines.each.with_index do |machine, i|
        puts "#{i+1}) #{machine}"
      end
      number = STDIN.gets.strip.to_i
      machine_name = machines[number-1]
    end

    set_docker_env(machine_name)
    puts "Deploying to #{ENV['DOCKER_MACHINE_NAME']} (#{ENV['DOCKER_HOST']})"
  end

  desc "rebuild and restart the server"
  task :up do
    dprod "up --build -d"
  end

  desc "stop the server"
  task :stop do
    dprod "stop"
  end

  desc "build the docker machine"
  task :build do
    dprod "build"
  end

  desc "prepare assets for nginx"
  task :assets do
    dprod "run --rm web bash -c 'rm -rf /public_web/* && cp -r public/* /public_web'"
  end

end
