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
      sleep 5
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

@test "clean up stuff" {
  run getent group management
  [[ $status -eq 0 ]]
}

@test "finds all users belonging to a group, primary and secondary members" {
  run getent group management
  [[ $status -eq 0 ]]
  [[ $output == *"management:x:10000:user001,user002,user003,user004,user005,user006,user007,user008,user009,user010,user011,user012,user013,user014,user015,user016,user017,\
user018,user019,user020,user021,user022,user023,user024,user025,user026,user027,user028,user029,user030,user031,user032,user033,user034,user035,user036,user037,user038,user039,\
user040,user041,user042,user043,user044,user045,user046,user047,user048,user049,user050,user051,user052,user053,user054,user055,user056,user057,user058,user059,user060,user061,\
user062,user063,user064,user065,user066,user067,user068,user069,user070,user071,user072,user073,user074,user075,user076,user077,user078,user079,user080,user081,user082,user083,\
user084,user085,user086,user087,user088,user089,user090,user091,user092,user093,user094,user095,user096,user097,user098,user099,user100,user101,user102,user103,user104,user105,\
user106,user107,user108"* ]]

  run getent group 10000
  [[ $status -eq 0 ]]
  [[ $output == *"management:x:10000:user001,user002,user003,user004,user005,user006,user007,user008,user009,user010,user011,user012,user013,user014,user015,user016,user017,\
user018,user019,user020,user021,user022,user023,user024,user025,user026,user027,user028,user029,user030,user031,user032,user033,user034,user035,user036,user037,user038,user039,\
user040,user041,user042,user043,user044,user045,user046,user047,user048,user049,user050,user051,user052,user053,user054,user055,user056,user057,user058,user059,user060,user061,\
user062,user063,user064,user065,user066,user067,user068,user069,user070,user071,user072,user073,user074,user075,user076,user077,user078,user079,user080,user081,user082,user083,\
user084,user085,user086,user087,user088,user089,user090,user091,user092,user093,user094,user095,user096,user097,user098,user099,user100,user101,user102,user103,user104,user105,\
user106,user107,user108"* ]]
}

@test "finds all groups a user belongs to" {
  run groups user001
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"management"* ]]
}

@test "finds all groups entries" {
  run getent group
  [[ "$status" -eq 0 ]]
  [[ "$output" == *"immortals:xxx*group_hashed_password*xxx:9000:katarina"* ]]
  [[ "$output" == *"final fantasy 15:x:9001:noctis,cindy,chocobo"* ]]
  [[ "$output" == *"final fantasy 7:x:9002:cloud,chocobo"* ]]
  [[ "$output" == *"management:x:10000:user001,user002,user003,user004,user005,user006,user007,user008,user009,user010,user011,user012,user013,user014,user015,user016,user017,\
user018,user019,user020,user021,user022,user023,user024,user025,user026,user027,user028,user029,user030,user031,user032,user033,user034,user035,user036,user037,user038,user039,\
user040,user041,user042,user043,user044,user045,user046,user047,user048,user049,user050,user051,user052,user053,user054,user055,user056,user057,user058,user059,user060,user061,\
user062,user063,user064,user065,user066,user067,user068,user069,user070,user071,user072,user073,user074,user075,user076,user077,user078,user079,user080,user081,user082,user083,\
user084,user085,user086,user087,user088,user089,user090,user091,user092,user093,user094,user095,user096,user097,user098,user099,user100,user101,user102,user103,user104,user105,\
user106,user107,user108"* ]]
}
