1.0.2
--------
  - used before_create callback to set the sandbox_id_field instead of the before_save, in this way the sandbox_id_field is only setted once
    when you create a new record
  
1.0.1
------
- Created the option to use a given set_sandbox_proc to set the
  sandbox_id
- Created the strategy options that allow you to use a given class as
  strategy
- Created the MultipleSandboxStrategy