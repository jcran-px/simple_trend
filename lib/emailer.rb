require 'net/smtp' 

module SimpleTrend

  class Emailer

    def send_email(to,opts={})
      opts[:server]      ||= 'pwnix-dev'
      opts[:from]        ||= 'daemon@simpletrend'
      opts[:from_alias]  ||= 'SimpleTrend'
      opts[:subject]     ||= "Something Changed!"
      opts[:body]        ||= "Something Changed on the network!"

      msg = <<-END_OF_MESSAGE
        #{opts[:body]}
      END_OF_MESSAGE

      Net::SMTP.start(opts[:server]) do |smtp|
        smtp.send_message msg, opts[:from], to
      end
    end

  end
end


x = SimpleTrend::Emailer.new.send_email("jcran@0x0e.org")
