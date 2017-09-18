module TelegramCommon
  class Telegram
    VERSION_REQUIRED = '~> 2.1'.freeze

    def execute(command, config_path: nil, logger: nil, args: {})
      @command     = command
      @args        = args
      @logger      = logger || TELEGRAM_CLI_LOG
      @config_path = config_path || PHANTOMJS_CONFIG

      debug(command)
      debug(args)

      make_request

      if response[0] == 'failed'
        raise TelegramCommon::Exceptions::Telegram, JSON.parse(response[1])['description']
      end

      response[1]
    end

    def reset
      FileUtils.rm_rf(Dir.glob("#{local_storage}/*"))
    end

    def rails_env_valid?
      Rails.env.production?
    end

    def phantomjs_version_valid?
      Gem::Dependency.new('', VERSION_REQUIRED).match?('', phantomjs_version)
    end

    def webogram_valid?
      Timeout::timeout(5) {
        execute('Test')
      }
    rescue
      false
    end

    def phantomjs_version
      `#{phantomjs} -v`.strip
    end

    def phantomjs
      `which phantomjs`.strip
    end

    def local_storage
      Rails.root.join('tmp', 'telegram_common')
    end

    def api_url
      params = {
        command: command,
        args: args.to_json
      }

      "#{base_api}#/api?#{params.to_query}"
    end

    def base_api
      if Rails.env.development?
       # gulp watch on app/webogram
       'http://localhost:8000/app/index.html'
      else
       "#{Setting.protocol}://#{Setting.host_name}/plugin_assets/redmine_telegram_common/webogram/index.html"
      end
    end

    private

    attr_reader :command, :args, :config_path, :logger, :api_result

    def make_request
      @api_result = `#{cli_command}`
      debug(api_result)
      api_result
    end

    def cli_command
      cmd = "#{phantomjs} --local-storage-path=\"#{local_storage}\" --ignore-ssl-errors=yes #{config_path} \"#{api_url}\""
      debug(cmd)
      cmd
    end

    def debug(message)
      log(message)
    end

    def log(message, operation: 'debug')
      if logger && message
        logger.public_send(operation, message)
      end
    end

    def response
      api_result.scan(/(success|failed): (.*)/).flatten
    end
  end
end
