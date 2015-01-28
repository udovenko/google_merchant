module GoogleMerchant
  
  
  # Google Product Category model. Creates a table of nested categories based on
  # Google categories plain text file.
  #
  # @author Denis Udovenko
  # @version 1.0.1
  class Category < ActiveRecord::Base
    
    
    TAXONOMY_FILE_CATEGORIES_SEPARATOR = ' > '
    
    
    # Awesome nested set tree settings:
    acts_as_nested_set left_column: :left, right_column: :right 
  
  
    # Retrieved models should be sorted by left key by default: 
    default_scope { order(:left) }
    
    
    # Reads Google Product Categories plain text file and adds new categories
    # to the table.
    def self.update
      open(GoogleMerchant::configuration.taxonomy_file_url, "r") do |file|
        
        while(line = file.gets)
          line.strip!.force_encoding('UTF-8')
          next if line.start_with?('#')
          
          puts "processing line: #{line}..."
          category_names_from_file = line.split(TAXONOMY_FILE_CATEGORIES_SEPARATOR)
          
          parent_category_model = nil
          
          category_names_from_file.each do |category_name_from_file|
            attr_hash = { name: category_name_from_file }
            
            # If current node is a root in the source line:
            unless parent_category_model
              category_model = self.roots.find_by(attr_hash)
              if category_model
                parent_category_model = category_model
              else
                puts "adding new root #{category_name_from_file}..."
                category_model = self.create!(attr_hash)
                parent_category_model = category_model
              end  
            
            # If current node is a child of current parent category in the source line:  
            else
              category_model = parent_category_model.children.find_by(attr_hash)
              if category_model
                parent_category_model = category_model
              else
                puts "adding new child #{category_name_from_file} for #{parent_category_model.name}"
                category_model = self.create!(attr_hash)
                category_model.move_to_child_of(parent_category_model)
                parent_category_model = category_model
              end
            end  
          end
        end
      end
    end
  end
end