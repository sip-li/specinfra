class Specinfra::Command::Alpine::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "s6-svstat /var/run/s6/services/#{escape(service)} | grep up"
    end

    def check_is_running(service)
      "s6-svstat /var/run/s6/services/#{escape(service)} | grep up"
    end
  end
end
