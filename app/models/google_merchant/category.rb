module GoogleMerchant
  
  
  # Google Product Category model. Creates a table of nested categories based on
  # Google categories plain text file.
  #
  # @author Denis Udovenko
  # @version 1.0.3
  class Category < ActiveRecord::Base
    
    
    TAXONOMY_FILE_CATEGORIES_SEPARATOR = ' > '
    
    
    # Awesome nested set tree settings:
    acts_as_nested_set left_column: :left, right_column: :right 
  
  
    # Retrieved models should be sorted by left key by default: 
    default_scope { order(:left) }
    
    
    # Reads Google Product Categories plain text file and adds new categories
    # to the table.
    def self.update
      beginning_time = Time.now
      initial_record_count = self.count
      
      open(GoogleMerchant::configuration.taxonomy_file_url, "r") do |file|
        
        while(line = file.gets)
          line.strip!.force_encoding('UTF-8')
          next if line.start_with?('#')
          
          puts "processing line: #{line}:"
          category_names_from_file = line.split(TAXONOMY_FILE_CATEGORIES_SEPARATOR)
       
          conditions = not_in_cashe?(category_names_from_file)
          if conditions
            if conditions[:parent_model]
              puts " - creating node \"#{conditions[:category_name]}\""
              parent = conditions[:parent_model]
              category_model = self.create!(name: conditions[:category_name])            
              category_model.move_to_child_of(parent)
              parent.reload
            else
              category_model = self.roots.find_by(name: conditions[:category_name])
              unless category_model
                puts " - creating root \"#{conditions[:category_name]}\""
                category_model = self.create!(name: conditions[:category_name]) 
              else
                puts " - root found in database"
              end  
              @cash << category_model
            end
          end
        end
        
        end_time = Time.now
        record_count_after_complete = self.count
        puts "Time elapsed: #{(end_time - beginning_time)} seconds"
        puts "Records created: #{(record_count_after_complete - initial_record_count)}" 
      end
    end
    
    
    private
    
      
      #
      #
      def self.not_in_cashe?(category_names_array)
        @cash ||= []
        
        parent_cash_node = nil

        category_names_array.each do |category_name|
          
          # If current node name is a name of root:
          unless parent_cash_node
            print " - looking for root \"#{category_name}\"..."
            category_cash_node = @cash.detect { |root_node| root_node.name == category_name }
            unless category_cash_node
              return { 
                category_name: category_name
              }
            else
              puts "found in cache"
              parent_cash_node = category_cash_node
            end  
          
          # If current node is a child of current parent category in the source line:    
          else
            print " - looking for child \"#{category_name}\" in \"#{parent_cash_node.name}\"..."
            category_cash_node = load_and_detect(parent_cash_node.children, {name: category_name})
            unless category_cash_node
              return { 
                parent_model: parent_cash_node, 
                category_name: category_name
              }
            else
              parent_cash_node = category_cash_node
            end
          end  
        end
        
        return false
      end
      
      
      #
      #
      def self.load_and_detect(association, conditions)
        in_cache = association.loaded?

        result = association.detect do |model|
          found = true
          conditions.each do |key, value|
            found = false unless model.send(key) == value
          end
          found
        end
        
        if result
          puts(in_cache ? "found in cache" : "found in database")
        else
          puts "not found"
        end  
        
        result
      end
  end
end