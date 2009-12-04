module Mingle4r
  class API
    class V2
      class Card
        class Transition
          extend Mingle4r::CommonClassMethods

          module InstanceMethods
            def execute(args = {})
              args.symbolize_keys!
              trans_exec_xml = convert_to_xml(args)
              # set_transition_execution_attributes
              conn = self.class.connection
              url_path =URI.parse(transition_execution_url()).path 
              conn.post(url_path, trans_exec_xml, self.class.headers)
            end

            private
            def convert_to_xml(args)
              hash = create_transition_exec_hash(args)
              xmlize_trans_exec(hash)
            end
            
            def create_transition_exec_hash(args)
              transition_hash = {}
              transition_hash['card'] = (args.delete(:card) || associated_card_number).to_i
              args.delete(:name) || args.delete(:transition)
              
              comment = args.delete(:comment)
              transition_hash['comment'] = comment if comment
              properties = []
              args.each do |name, value|
                property = {'name' => name.to_s, 'value' => value}
                properties.push(property)
              end
              transition_hash['properties'] = properties unless properties.empty?
              transition_hash
            end
            
            def xmlize_trans_exec(hash)
              hash.to_xml(:root => 'transition_execution', :dasherize => false)
            end
            
            def associated_card_number
              File.basename(self.class.site.to_s).to_i
            end
          end
        end
      end
    end
  end
end