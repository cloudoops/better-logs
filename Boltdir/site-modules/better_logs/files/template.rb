#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

############################
# Class for string color
############################
class String
    def black;          "\e[30m#{self}\e[0m" end
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def brown;          "\e[33m#{self}\e[0m" end
    def blue;           "\e[34m#{self}\e[0m" end
    def magenta;        "\e[35m#{self}\e[0m" end
    def cyan;           "\e[36m#{self}\e[0m" end
    def gray;           "\e[37m#{self}\e[0m" end
    def yellow;         "\e[93m#{self}\e[0m" end

    def bg_black;       "\e[40m#{self}\e[0m" end
    def bg_red;         "\e[41m#{self}\e[0m" end
    def bg_green;       "\e[42m#{self}\e[0m" end
    def bg_brown;       "\e[43m#{self}\e[0m" end
    def bg_blue;        "\e[44m#{self}\e[0m" end
    def bg_magenta;     "\e[45m#{self}\e[0m" end
    def bg_cyan;        "\e[46m#{self}\e[0m" end
    def bg_gray;        "\e[47m#{self}\e[0m" end
    def bg_dgray;       "\e[100m#{self}\e[0m"end

    def bold;           "\e[1m#{self}\e[22m" end
    def italic;         "\e[3m#{self}\e[23m" end
    def underline;      "\e[4m#{self}\e[24m" end
    def blink;          "\e[5m#{self}\e[25m" end
    def reverse_color;  "\e[7m#{self}\e[27m" end
end


class Slave
    def initialize(params)
        @result = {}
        @params = params
        if @params["debug"]
            @DEBUG = @params["debug"]
        else
            @DEBUG = false
        end
        if @params["verbose"]
            @VERBOSE = @params["verbose"]
        else
            @VERBOSE = false
        end
        if @params["retry"]
            @RETRY = @params["retry"]
        else
            @RETRY = false
        end
        # @params['_task'] = "test::#[task]"
        ##############################
        # Transform paramters
        ##############################
        # case @params["certnames"]
        # when Array
        #     @certnames = @params["certnames"]
        # when String
        #     @certnames = @params["certnames"].split(",")
        #     @certnames = certnames.map {|certname| certname.strip }
        # end
    end
    # need logic to determine if task is remote or not
    def execute(filename, command, error)
        # Execute Command
        @result[:_task] = filename
        @result[:_timestamp]= Time.now.to_i
        # @result[:_date]
        unless @params["_target"]["remote"].nil?
            begin 
                stdout, stderr, status = Open3.capture3(*command)
                rescue Exception => e
                default_error = {                             
                    msg: e.message,
                    kind: "test::#{filename}",
                    details: { class: e.class.to_s,
                                backtrace: e.backtrace },  
                    }
                @result[:_error] = default_error.merge(error)

            end
            @result[:_stdout] = stdout
            @result[:_sterr] = stderr
            @result[:_status] = status
            @result
        else
            @result[:_timestamp]= Time.now
            @result[:_command_start_time] = Time.now
            begin   
                $results = command.call()
                @result[:_command_end_time] = Time.now
                rescue Exception => e
                @result[:_command_end_time] = Time.now
                default_error = {                             
                    msg: e.message,
                    kind: "test::#{filename}",
                    details: { class: e.class.to_s,
                                backtrace: e.backtrace },  
                    }
                @result[:_error] = default_error.merge(error)
                #puts @result
            end
            # makes sure the results are at the top level of the return object
            unless $results.nil?
                $results.each do |key, value|
                    @result[key] = value
                end
            end
        end
    @result
    end # execute
end
        # Instantiate container log, assuming failure

        # Commenting out for debugging purposes
        # @result[certname][$puppet_hostname][:Clean] = { 
        #     CLEANED: false,
        #     CMD: @command,
        #     START: timestamp,      
        #     STDOUT: stdout.to_s.strip,
        #     STDERR: stderr.to_s.strip,
        #     STATUS: status.to_s.strip,
        # }
        # Define printout if verbose is requested   
        #   
        # if DEBUG || VERBOSE
        #     puts "#Executing #{@command} on {certname.upcase}...".green
        #     puts "<Status> ".blue + status.inspect + "<Status Complete>".blue
        #     puts "<Stdout> ".green + stdout.to_s + "<Stdout Complete>".green
        #     puts "<Stderr> ".red + stderr.to_s + "<Stderr Complete>".red
        #     puts "'status.to_s[-1].to_i': " +  status.to_s[-1].to_i
        #     puts "'status.to_s[-1].to_i.zero?': " +  status.to_s[-1].to_i.zero?
        #     puts "#######################################################################".bg_dgray
        #     puts "\n"
        # end
        # Change 'CLEANED' status to true if command succeeded
        # if status.to_s[-1].to_i.zero? || status.to_s[-1].to_i == 1
        #     @result[certname][$puppet_hostname][:Clean][:CLEANED] = true
        # end                      
     # puppet_clean

    ####################################################################
    # Printout banner to know which puppet is running on Debug/Verbose #
    # ####################################################################
    # if DEBUG || VERBOSE
    #     puts "#{'#' * 71}\r".bg_dgray
    #     puts "#{'#' * 4}".bg_dgray + "\s\s#{$.upcase}\s\s".yellow + "#{ '#' * (63 - $.length)}".bg_dgray
    #     puts "#{'#' * 71}\r".bg_dgray
    # end


    # if DEBUG || VERBOSE
    # # Final Ouputu Banner
    # puts "#{'#' * 71}".magenta
    # puts "#{'#' * 4}".magenta + "\s\sFinal Output\s\s".yellow + "#{ '#' * (63 - 'final output'.length)}".magenta
    # puts "#{'#' * 71}".magenta
    # puts JSON.pretty_generate($result)
    # end
    # # Final Output
    # puts JSON.dump($result)
