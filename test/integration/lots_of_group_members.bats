#!/usr/bin/env bats

setup() {
  if [[ "$BATS_TEST_NUMBER" -eq 1 ]]; then
    if [[ -z $DOCKER ]]; then
      cat /home/libnss-maria/examples/sos-sso/sql/1-db.sql | \
      sudo mysql -u root &&
      cat /home/libnss-maria/examples/sos-sso/sql/2-users.sql | \
      sudo mysql -u root &&
      cat /home/libnss-maria/examples/sos-sso/sql/3-data-structures.sql | \
      sudo mysql -u root sos-sso-production &&
      cat /home/libnss-maria/examples/sos-sso/sql/4-privileges.sql | \
      sudo mysql -u root sos-sso-production &&
      cat /home/libnss-maria/examples/sos-sso/sql/5-data.sql | \
      sudo mysql -u root sos-sso-production
      cat /home/libnss-maria/test/fixtures/lots_of_group_members.sql | \
      sudo mysql -u root sos-sso-production
    else
      cat /home/libnss-maria/examples/sos-sso/sql/1-db.sql | \
      mysql -unss-maria-user -pIsabelle -hdatabase sos-sso-production &&
      cat /home/libnss-maria/examples/sos-sso/sql/3-data-structures.sql | \
      mysql -unss-maria-user -pIsabelle -hdatabase sos-sso-production &&
      cat /home/libnss-maria/examples/sos-sso/sql/5-data.sql | \
      mysql -unss-maria-user -pIsabelle -hdatabase sos-sso-production
    fi
  fi
}

@test "finds all users belonging to a group, primary and secondary members" {
  run getent group management
  [[ $status -eq 0 ]]
  [[ $output == *"management:x:10000:noctis,cindy,chocobo"* ]]

  run getent group 10000
  [[ $status -eq 0 ]]
  [[ $output == *"management:x:10000:noctis,cindy,chocobo"* ]]
}

@test "finds all groups a user belongs to" {
  run groups user001
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"management"* ]]
}

#@test "finds all groups entries" {
#  run getent group
#  [[ "$status" -eq 0 ]]
#  [[ "$output" == *"immortals:xxx*group_hashed_password*xxx:9000:katarina"* ]]
#  [[ "$output" == *"final fantasy 15:x:9001:noctis,cindy,chocobo"* ]]
#  [[ "$output" == *"final fantasy 7:x:9002:cloud,chocobo"* ]]
#}
