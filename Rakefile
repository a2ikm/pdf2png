CC = ENV["CC"] || "gcc"

task :default => :build

task :build do
  out = "pdf2png"
  frameworks = %w(Foundation AppKit Quartz)

  options = [
    frameworks.map { |f| %W(-framework #{f}) },
    %W(-o #{out}), 
  ].flatten.join(" ")

  cmd = "#{CC} #{options} main.m"
  puts cmd
  system(cmd)
end
