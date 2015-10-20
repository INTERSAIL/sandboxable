# Sandboxable

## When to use this gem

If you need to separate your dataset for different users or group of users using the same DB.

## Install

 - Add to your gemfile: ```gem 'sandboxable', :git => 'git@github.com:INTERSAIL/sandboxable.git'```
 - Run ```bundle install```

### How to use

 - You need to include include Sandboxable::ActiveRecord in your model Class (it needs to extend ActiveRecord::Base).
 - You need to set globally the current sandbox id with: Sandboxable::ActiveRecord.current_sandbox_id(new_value) or Sandboxable::ActiveRecord.current_sandbox_id=new_value, you can also use the Kernel method current_sandbox_id(value) if you like
 - You can fetch the current_sandbox_id with Sandboxable::ActiveRecord.current_sandbox_id or current_sandbox_id (with no param given)

 It Works! Now by default you filtered all the rows with sandbox_id = Sandboxable::ActiveRecord.current_sandbox_id

#### Options

 - You can change the name of the colum to use with sandbox_with passing the field option. Example:
 ```ruby
 class Sandboxable < ActiveRecord::Base
    include Sandboxable::ActiveRecord
    
    sandbox_with field: :another_sandbox_id_column
 end
 ```
 
 - The sandbox field value will be set before_save by default with the Sandboxable::ActiveRecord.current_sandbox_id value.
   To disable that pass the persist: false option. Example: 
  ```ruby
  class Sandboxable < ActiveRecord::Base
      include Sandboxable::ActiveRecord
      
      sandbox_with persist: false
   end
   ```
 
 - The sandbox_field won't be serialized by default, you can enable that by setting the serialize_sandbox_field option to true.
   Example:
    ```ruby
    class Sandboxable < ActiveRecord::Base
      include Sandboxable::ActiveRecord
       
      sandbox_with serialize_sandbox_field: true
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
 
##### Skip sandbox check
  You can skip the sandbox check in two ways:
     - using unscoped method: be aware that you loose also all the other default scopes that belongs to the model
     - using the without_sandbox method that accepts a block and runs the code inside ignoring the sandbox proc, example:
           Model.without_sandbox {|obj| obj.all}
 
#### Additional Notes

Be aware that this gem does a little MonkeyPatching to AR scopes, check Sandboxable::ActiveRecord.active_record.rb:5 for more info.

 