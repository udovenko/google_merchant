module GoogleMerchant
  
  
  # Google Product Category model. Creates a table of nested categories based on
  # Google categories plain text file.
  #
  # @author Denis Udovenko
  # @version 1.0.4
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
      
      @cache = []
        
      # Open remote text file with Google product categories for further operations:
      open(GoogleMerchant::configuration.taxonomy_file_url, "r") do |file|
        
        while(line = file.gets)
          line.strip!.force_encoding('UTF-8')
          next if line.start_with?('#')
          
          puts "processing line: #{line}:" if self.verbose
          category_names_from_file = line.split(TAXONOMY_FILE_CATEGORIES_SEPARATOR)
       
          # If one of categories in hierarchy not found in cached roots or their descendants:
          category_creation_conditions = category_to_create(category_names_from_file)
          
          if category_creation_conditions
            parent = category_creation_conditions[:parent_model]
            category_name = category_creation_conditions[:category_name]
            category_name_attr = { name: category_name }
            
            # If cache contains category parent, create a child:
            if parent
              puts " - creating node \"#{category_name}\"" if self.verbose
              category_model = self.create!(category_name_attr)            
              category_model.move_to_child_of(parent)
              parent.reload
              parent.children.reload
              
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
              @cache << category_model
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
      # cache, returns category creation conditions.
      #
      # @param {Array} category_names_array Array with category names hierarchy
      # @return {Hash, false} Hash with missed category name and its cached parent (or nil, if root is missed) of false if hierarchy cached
      def self.category_to_create(category_names_array)
        parent_node_form_cache = nil

        category_names_array.each do |category_name|
          category_node_from_cache = in_cache?(parent_node_form_cache, category_name)
          
          return { 
            parent_model: parent_node_form_cache, 
            category_name: category_name } unless category_node_from_cache
         
          parent_node_form_cache = category_node_from_cache
        end  
        
        return false
      end
      
      
      # Checks if given category is cached by given category name and existing 
      # parent node.
      #
      # @param {Category, nil} parent_node_form_cache Existing parent node for sought-for category
      # @param {String} category_name Sought-for category name
      # @return {Category, nil} Found category node or nil
      def self.in_cache?(parent_node_form_cache, category_name)
        success_phrase = "found in cache"
        
        if parent_node_form_cache
          print " - looking for child \"#{category_name}\" in \"#{parent_node_form_cache.name}\"..." if self.verbose
          found_child_category = detect_model(parent_node_form_cache.children, {name: category_name})
          puts success_phrase if found_child_category && self.verbose
          return found_child_category
        else
          print " - looking for root \"#{category_name}\"..." if self.verbose
          found_root = @cache.detect { |root_node| root_node.name == category_name }
          puts success_phrase if found_root && self.verbose
          return found_root
        end  
      end
      
      
      # Searches for model with given conditions in children association's
      # collection.
      # 
      # @param {Association} association Parent category's has_many association
      # @param {Hash} conditions Search conditions hash
      # @return {Category, nil} Found Child category or nil
      def self.detect_model(association, conditions)
        association.detect do |model|
          found = true
          conditions.each do |key, value|
            found = false unless model.send(key) == value
          end
          found
        end
      end
  end
end