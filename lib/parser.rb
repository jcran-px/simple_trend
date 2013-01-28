require "nmap/parser"

module SimpleTrend
  class NmapParser
    def parse_and_print(xml_file)
      # Gather the XML and parse
      parser = Nmap::Parser.parsefile(xml_file)
    
      # Do something with each host that's alive
      parser.hosts("up") do |host|
    
        #print the host's address
        puts host.addr

        # Do something with each tcp / udp port
        [:tcp, :udp].each do |proto_type|
    
          # Only show open port info
          host.getports(proto_type, "open") do |port|
            puts "Port number: #{port.num}"
            puts "Port protocol: #{port.proto}"
            puts "Port fingerprint: #{port.service.name} #{port.service.product} #{port.service.version}"
          end
        end
      end
    end

   def parse_and_compare(xml_file)
      # Gather the XML and parse
      parser = Nmap::Parser.parsefile(xml_file)
    
      # Do something with each host that's alive
      parser.hosts do |host|
    
        #Get the host from the database
        x = Models::Host.last :address => host.addr
        
        # Check if we've seen it before
        if x 
          #puts "We last saw #{host.addr} at #{x.updated_at}"
        else
          puts "New host #{host.addr}"
        end

        # Do something with each tcp / udp port
        [:tcp, :udp].each do |proto_type|
        
          # Only show open port info
          host.getports(proto_type) do |port|

            # Get the port from the database
            y = Models::Port.last :port_num => port.num,
                                  :proto => port.proto,
                                  :host_id => x.id

            # Check if we've seen it before
            if y
              # If we've seen it before, see if it changed...
              if y.state != port.state
                "Huh, looks like #{port.num}/#{port.proto}/#{port.state} changed. It was #{y.port_num}/#{y.proto}/#{y.state}"
              end
              #puts "We last saw #{port.num}/#{port.proto} on host #{x.address} at #{y.updated_at}"
            else
              puts "New port #{port.num}/#{port.proto}/#{port.state} on host #{x.address}"
            end

          end 
        end
      end
    end

    def parse_and_store(xml_file)
      # Gather the XML and parse
      parser = Nmap::Parser.parsefile(xml_file)
    
      # Do something with each host that's alive
      parser.hosts("up") do |host|
    
        #print the host's address
        #puts "Creating Host: #{host.addr}"
        x = Models::Host.create(:address => host.addr)

        # Do something with each tcp / udp port
        [:tcp, :udp].each do |proto_type|
        
          # Only show open port info
          host.getports(proto_type) do |port|
            #puts "Creating Port: #{port.num}/#{port.proto}"
            #puts "Fingerprint: #{port.service.name} #{port.service.product} #{port.service.version}"
            Models::Port.create :port_num => port.num,
                                :proto => port.proto,
                                :name => port.service.name,
                                :service => port.service.product, 
                                :version => port.service.version,
                                :state => port.state,
                                :host_id => x.id
          end
        end
      end
    end

  end
end