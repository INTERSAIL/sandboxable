# Sandboxable

## When to use this gem

If you need to separate your dataset for different users or group of users using the same DB.

## Install

 - Add to your gemfile: ```gem 'sandboxable', :git => 'git@github.com:INTERSAIL/sandboxable.git'```
 - Run ```bundle install```

### How to use

 - You need to include include Sandboxable::ActiveRecord in your model Class (it needs to extend ActiveRecord::Base).
 - You need to set globally the current sandbox id with: Sandboxable::ActiveRecord.current_sandbox_id(value)

 It Works! Now by default you filted all the rows with sandbox_id = Sandboxable::ActiveRecord.current_sandbox_id

#### Options

 - You can change the name of the colum to use with sandbox_with passing the field option. Example:
 ```ruby
 class Sandboxable < ActiveRecord::Base
    include Sandboxable::ActiveRecord
    
    sandbox_with field: :another_sandbox_id_column
 end
 ```
 
 - The sandbox fiel value will be set before_save by default with the Sandboxable::ActiveRecord.current_sandbox_id value.
   To disable that pass the persist: false option. Example: 
  ```ruby
  class Sandboxable < ActiveRecord::Base
      include Sandboxable::ActiveRecord
      
      sandbox_with persist: false
   end
   ```
 
 - You can also use a proc for having a custom default scope. Example:
 ```ruby
 class Sandboxable < ActiveRecord::Base
     include Sandboxable::ActiveRecord
     
     sandbox_with do
       where(:sandbox_id => Sandboxable::ActiveRecord.current_sandbox_id)
     end
  end
  ```
  
  NOTE: You can use ```Sandboxable::ANY_SANDBOX``` for current sandbox_id and that allow
  you to skip the sandbox_id data partitioning
 
#### Additional Notes

Be aware that this gem does a little MonkeyPatching to AR scopes, check Sandboxable::ActiveRecord.active_record.rb:5 for more info.

 