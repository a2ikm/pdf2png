CC = ENV["CC"] || "gcc"
PROGNAME = "pdf2png"
FRAMEWORKS = %w(Foundation AppKit Quartz)

task :default => :build

def options(*args)
  opts = []
  opts << %W(-v) if ENV["DEBUG"]

  (opts + args).flatten.join(" ")
end

def compile(filename, *opts)
  opts = options(*opts)
  sh "#{CC} #{opts} #{filename}"
end

def link_(*filenames)
  opts = options(
            FRAMEWORKS.map { |f| %W(-framework #{f}) },
            %W(-o #{PROGNAME})
          )
  sh "#{CC} #{filenames.join(" ")} #{opts}"
end

task :build do
  Dir.chdir(File.dirname(__FILE__)) do
    system("mkdir -p build")

    compile("src/main.m",       "-c", "-o build/main.o")
    compile("src/Converter.m",  "-c", "-o build/Converter.o")
    link_("build/Converter.o", "build/main.o")
  end
end
