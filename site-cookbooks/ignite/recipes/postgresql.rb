# Ignite::postgress
#   Install postgresql
#
include_recipe "postgresql::server"
include_recipe "postgresql::contrib"
include_recipe "postgresql::libpq"
