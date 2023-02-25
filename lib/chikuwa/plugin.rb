# frozen_string_literal: true

module Danger
  class DangerChikuwa < Plugin
    attr_accessor :project_root, :inline_mode

    def _project_root
      root = @project_root || Dir.pwd
      root += "/" unless root.end_with? "/"
      root
    end

    def _inline_mode
      @inline_mode || false
    end

    def report(file_path)
      if File.exist?(file_path)
        results = parse_build_log(file_path)
        send_reports(results)
      else
        fail "build log file not found"
      end
    end

    private

    module Type
      WARN = "w"
      ERROR = "e"
    end

    class ReportData
      attr_accessor :message, :type, :file, :line

      def initialize(message, type, file, line)
        self.message = message
        self.type = type
        self.file = file
        self.line = line
      end
    end

    def parse_build_log(file_path)
      report_data = []
      File.foreach(file_path) do |line|
        logs = line.split(":")
        if logs.length < 4
          next
        end

        case logs[0]
        when "w"
          type = Type::WARN
        when "e"
          type = Type::ERROR
        else
          next
        end

        path = [logs[1], logs[2]].join(":").strip
        case path
        when %r{^file:///.*}
          # kotlin 1.8 or later
          file = Pathname(logs[2].gsub(%r{^//}, "")).relative_path_from(_project_root).to_s
          line_num = logs[3].to_i
          logs.shift(4)
          message = logs.join(":").gsub(/^(\d+)\w/, "").strip!
        when %r{^/.*: \(\d+, \d+\)$}
          # kotlin 1.7 or earlier
          file = Pathname(logs[1].strip).relative_path_from(_project_root).to_s
          line_num = /(\d+)/.match(logs[2].strip).to_a[0].to_i
          logs.shift(3)
          message = logs.join(":").strip!
        else
          next
        end
        report_data.push(ReportData.new(message, type, file, line_num))
      end

      return report_data
    end

    def send_reports(results)
      results.each do |data|
        send(data)
      end
    end

    def send(data)
      case data.type
      when Type::WARN
        if _inline_mode
          warn(data.message, file: data.file, line: data.line)
        else
          warn(data.message)
        end
      when Type::ERROR
        if _inline_mode
          failure(data.message, file: data.file, line: data.line)
        else
          failure(data.message)
        end
      end
    end
  end
end
