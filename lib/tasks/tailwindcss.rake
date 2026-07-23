# frozen_string_literal: true

# Override tailwindcss-rails's tailwindcss:watch so the underlying binary
# keeps watching after stdin closes. Without `always`, the standalone
# tailwindcss binary exits as soon as stdin closes — which happens immediately
# when foreman or a bare shell launches the task. The `always` modifier tells
# the binary to keep watching until SIGINT/SIGTERM.
#
# After this override, plain `bin/rails tailwindcss:watch` (no extra args)
# works under foreman.
if Rake::Task.task_defined?("tailwindcss:watch")
  Rake::Task["tailwindcss:watch"].clear

  namespace :tailwindcss do
    desc "Watch and build your Tailwind CSS on file changes"
    task watch: [:environment, :engines] do |_, args|
      debug   = args.extras.include?("debug")
      silent  = args.extras.include?("silent")
      verbose = args.extras.include?("verbose")

      command = Tailwindcss::Commands.watch_command(always: true, debug: debug, silent: silent)
      env     = Tailwindcss::Commands.command_env(verbose: verbose)
      puts "Running: #{Shellwords.join(command)}" if verbose

      received_signal = Tailwindcss::ProcessRunner.spawn_and_wait(env, *command)
      puts "Received #{received_signal}, exiting tailwindcss:watch" if verbose && received_signal
    end
  end
end
