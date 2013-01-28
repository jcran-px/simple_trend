module SimpleTrend
  module Models
    class Port  
      include ::DataMapper::Resource  
      belongs_to :host
      property :id          , Serial
      property :port_num    , Integer
      property :proto       , String
      property :state       , String
      property :service     , String
      property :name        , String
      property :version     , String 
      property :created_at  , DateTime
      property :updated_at  , DateTime
    end
  end
end