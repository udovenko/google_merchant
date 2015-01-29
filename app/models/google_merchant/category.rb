module GoogleMerchant
  
  
  # Google Product Category model. Creates a table of nested categories based on
  # Google categories plain text file.
  #
  # @author Denis Udovenko
  # @version 1.0.3
  class Category < ActiveRecord::Base
    
    
    TAXONOMY_FILE_CATEGORIES_SEPARATOR = ' > '
    
    
    class << self
      attr_accessor :verbose
    end
    
    
    # Awesome nested set tree settings:
    acts_as_nested_set left_column: :left, right_column: :right 
  
  
    # Retrieved models should be sorted by left key by default: 
    default_scope { order(:left) }
    
    
    # Reads Google Product Categories plain text file and adds new categories
    # to the table. Calculates elapsed time and count of created records in 
    # verbose mode.
    def self.update
      
      # Remember initial time and record count for verbose mode:
      if self.verbose
        beginning_time = Time.now
        initial_record_count = self.count
      end
        
      # Open remote text file with Google product categories for further operations:
      open(GoogleMerchant::configuration.taxonomy_file_url, "r") do |file|
        
        while(line = file.gets)
          line.strip!.force_encoding('UTF-8')
          next if line.start_with?('#')
          
          puts "processing line: #{line}:" if self.verbose
          category_names_from_file = line.split(TAXONOMY_FILE_CATEGORIES_SEPARATOR)
       
          # If one of categories in hierarchy not found in cached roots or their descendants:
          category_missing_conditions = includes_not_cashed_category?(category_names_from_file)
          if category_missing_conditions
            parent = category_missing_conditions[:parent_model]
            category_name = category_missing_conditions[:category_name]
            category_name_attr = { name: category_name }
            
            # If cache contains category parent, create a child:
            if parent
              puts " - creating node \"#{category_name}\"" if self.verbose
              category_model = self.create!(category_name_attr)            
              category_model.move_to_child_of(parent)
              parent.reload
              
            # If category is root and not in the cache:  
            else
              
              # Create root if it's not in database:
              category_model = self.roots.find_by(category_name_attr)
              unless category_model
                puts " - creating root \"#{category_name}\"" if self.verbose
                category_model = self.create!(category_name_attr) 
              else
                puts " - root found in database" if self.verbose
              end
              @cash << category_model
            end
          end
        end
        
        # Print benchmark results for verbose mode:
        if self.verbose
          end_time = Time.now
          record_count_after_complete = self.count
          puts "Time elapsed: #{(end_time - beginning_time)} seconds"
          puts "Records created: #{(record_count_after_complete - initial_record_count)}" 
        end
      end
    end
    
    
    private
    
      
      # Checks if given category names are cached as root models or their
      # descendants. If one of category names has no corresponding node in 
      # cache.
      #
      # @param {Array} category_names_array Array with category names hierarchy
      # @return {Hash, false} Hash with missed category name and its cashed parent (or nil, if root is missed) of false if hierarchy cashed
      def self.includes_not_cashed_category?(category_names_array)
        @cash ||= []
        
        parent_cash_node = nil

        category_names_array.each do |category_name|
          
          # If current node name is a name of root:
          unless parent_cash_node
            print " - looking for root \"#{category_name}\"..." if self.verbose
            category_cash_node = @cash.detect { |root_node| root_node.name == category_name }
            
            return { category_name: category_name } unless category_cash_node
                        
            puts "found in cache" if self.verbose
            parent_cash_node = category_cash_node
                   
          # If current node is a child of current parent category in the source line:    
          else
            print " - looking for child \"#{category_name}\" in \"#{parent_cash_node.name}\"..." if self.verbose
            category_cash_node = load_and_detect(parent_cash_node.children, {name: category_name})
            
            return { 
              parent_model: parent_cash_node, 
              category_name: category_name 
            } unless category_cash_node
           
            parent_cash_node = category_cash_node
          end  
        end
        
        return false
      end
      
      
      # Searches for model with given conditions in children association's
      # collection.
      # 
      # @param {Association} association Parent category's has_many association
      # @param {Hash} conditions Search conditions hash
      # @return {Category, nil} Found Child category or nil
      def self.load_and_detect(association, conditions)
        in_cache = association.loaded?

        result = association.detect do |model|
          found = true
          conditions.each do |key, value|
            found = false unless model.send(key) == value
          end
          found
        end
        
        if self.verbose
          if result
            puts(in_cache ? "found in cache" : "found in database")
          else
            puts "not found"
          end  
        end
        
        result
      end
  end
end