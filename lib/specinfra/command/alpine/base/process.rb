class Specinfra::Command::Alpine::Base::Process < Specinfra::Command::Base
  class << self
    def get(process, opts)
      col = opts[:format].chomp('=')
      if col == 'args'
        # "ps -o #{col} | grep #{escape(process)} | head -1"
        "bash -c \"ps -o #{col} | grep #{escape(process)} | if [[ #{escape(process)} =~ ^s6-supervise ]]; then grep -v grep; else grep -v grep | grep -v s6-supervise; fi | head -1 \" "
      else
        # "bash -c \"ps -o #{col},args | grep \'#{escape(process)}' | if [[ #{escape(process)} =~ ^s6-supervise ]]; then grep -v grep; else grep -v grep | grep -v s6-supervise; fi | awk '{ print $1 }' | head -1\""
        "bash -c \"ps -o #{col},args | grep #{process} | if [[ #{escape(process)} =~ ^s6-supervise ]]; then grep -v grep; else grep -v grep | grep -v s6-supervise; fi | tr -s ' ' | cut -d' ' -f1 | head -1 \" "
        # "ps -o #{col},args | grep -E '\\s+#{process}' | awk '{ print $1 }' | head -1"
      end
    end

    def check_is_running(process)
      # "ps -o args | grep -w -- #{process} | grep -qv grep"
      # "ps -o args | grep #{escape(process)} | if [[ #{escape(process)} =~ ^s6-supervise ]]; then grep -v grep; else grep -v grep | grep -v s6-supervise; fi"
      "bash -c \"ps -o args | grep #{escape(process)} | if [[ #{escape(process)} =~ ^s6-supervise ]]; then grep -vq grep; else grep -vq grep\""
      # $stdout.write "ps -o args | grep \"#{escape(process)}\" | if [[ \"$#{escape(process)}\" =~ ^s6-supervise ]]; then grep -v grep; else grep -v grep | grep -v s6-supervise; fi"
    end

    def check_count(process, count)
      # "test $(ps -o args | grep -w -- #{process} | grep -v grep | wc -l) -eq #{count}"
      "bash -c \"test $(ps -o args | grep #{escape(process)} | if [[ #{escape(process)} =~ ^s6-supervise ]]; then grep -v grep; else grep -v grep | grep -v s6-supervise; fi | wc -l) -eq #{escape(count)}\""
      # $stdout.write "test $(ps -o args | grep \"#{escape(process)}\" | if [[ #{escape(process)} =~ ^s6-supervise ]]; then grep -v grep; else grep -v grep | grep -v s6-supervise; fi | wc -l) -eq #{escape(count)}"
    end
  end
end
