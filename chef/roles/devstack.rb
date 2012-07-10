name "devstack"
description "Devstack Role"
run_list(
         "recipe[devstack::install]"
)
default_attributes()
override_attributes()

