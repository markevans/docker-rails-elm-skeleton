task :default do
  system "rake -T"
end

DC_CONFIG = {
  dev: 'docker-compose.dev.yml',
  prod: 'docker-compose.prod.yml'
}

def dc(env, args)
  config_file = DC_CONFIG[env] || raise("Unknown docker-compose config #{env}")
  system "docker-compose -f #{config_file} #{args}"
end

desc "start dev on specified docker machine"
task :dev => [
    "docker:set_machine",
    "dev:up"
  ] do
end

desc "deploy to specified docker machine"
task :deploy => [
    "docker:set_machine",
    "deploy:stop",
    "deploy:build",
    "deploy:assets",
    "deploy:up"
  ] do
end

namespace :docker do

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
    puts "Docker pointing to #{ENV['DOCKER_MACHINE_NAME']} (#{ENV['DOCKER_HOST']})"
  end
end

namespace :dev do

  desc "rebuild and restart the server"
  task :up do
    dc :dev, "up --build"
  end

end

namespace :deploy do

  desc "rebuild and restart the server"
  task :up do
    dc :prod, "up --build -d"
  end

  desc "stop the server"
  task :stop do
    dc :prod, "stop"
  end

  desc "build the docker machine"
  task :build do
    dc :prod, "build"
  end

  desc "prepare assets for nginx"
  task :assets do
    dc :prod, "run --rm web bash -c 'rm -rf /public_web/* && cp -r public/* /public_web'"
  end

end
