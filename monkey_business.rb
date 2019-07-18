module ReportBuilder

  # ##
  # # ReportBuilder Main class
  # #
  class Builder

    ##
    # ReportBuilder Main method
    #
    def build_report
      options = ReportBuilder.options

      groups = get_groups options[:input_path]

      json_report_path = options[:json_report_path] || options[:report_path]
      if options[:report_types].include? 'JSON'
        File.open(json_report_path + '.json', 'w:UTF-8') do |file|
          file.write JSON.pretty_generate(groups.size > 1 ? groups : groups.first['features'])
        end
      end

      if options[:additional_css] and Pathname.new(options[:additional_css]).file?
        options[:additional_css] = File.read(options[:additional_css])
      end

      if options[:additional_js] and Pathname.new(options[:additional_js]).file?
        options[:additional_js] = File.read(options[:additional_js])
      end

      html_report_path = options[:html_report_path] || options[:report_path]
      if options[:report_types].include? 'HTML'
        File.open(html_report_path + '.html', 'w:UTF-8') do |file|
          file.write get(groups.size > 1 ? 'group_report' : 'report').result(binding).gsub('  ', '').gsub("\n\n", '')
        end
      end

      retry_report_path = options[:retry_report_path] || options[:report_path]
      if options[:report_types].include? 'RETRY'
        File.open(retry_report_path + '.retry', 'w:UTF-8') do |file|
          groups.each do |group|
            group['features'].each do |feature|
              if feature['status'] == 'broken'
                feature['elements'].each do |scenario|
                  file.puts "#{feature['uri']}:#{scenario['line']}" if scenario['status'] == 'failed'
                end
              end
            end
          end
        end
      end
      [json_report_path, html_report_path, retry_report_path]
    end

  #   ##
  #   # ReportBuilder Main method
  #   def build_report
  #     options = ReportBuilder.options
  #
  #     groups = get_groups options[:input_path]
  #
  #     json_report_path = options[:json_report_path] || options[:report_path]
  #     if options[:report_types].include? 'JSON'
  #       File.open(json_report_path + '.json', 'w') do |file|
  #         file.write JSON.generate(groups.size > 1 ? groups : groups.first['features'])
  #       end
  #     end
  #
  #     if options[:additional_css] and Pathname.new(options[:additional_css]).file?
  #       options[:additional_css] = File.read(options[:additional_css])
  #     end
  #
  #     if options[:additional_js] and Pathname.new(options[:additional_js]).file?
  #       options[:additional_js] = File.read(options[:additional_js])
  #     end
  #
  #     html_report_path = options[:html_report_path] || options[:report_path]
  #     if options[:report_types].include? 'HTML'
  #       File.open(html_report_path + '.html', 'w') do |file|
  #         file.write get(groups.size > 1 ? 'group_report' : 'report').result(binding).gsub('  ', '').gsub("\n\n", '')
  #       end
  #     end
  #
  #     retry_report_path = options[:retry_report_path] || options[:report_path]
  #     if options[:report_types].include? 'RETRY'
  #       File.open(retry_report_path + '.retry', 'w') do |file|
  #         groups.each do |group|
  #           group['features'].each do |feature|
  #             if feature['status'] == 'broken'
  #               feature['elements'].each do |scenario|
  #                 file.puts "#{feature['uri']}:#{scenario['line']}" if scenario['status'] == 'failed'
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end
  #     [json_report_path, html_report_path, retry_report_path]
  #   end
  end
end

