module SimpleTrend
  module Models
    class Host 
      include ::DataMapper::Resource 
      has n, :ports
      property :id            , Serial
      property :address       , String  
      property :hostname      , String
      property :created_at    , DateTime
      property :updated_at    , DateTime
    end
  end
end