class cinder::limits (
  $limits = 
{ 'POST' => '10',
 'POST_SERVERS' => '50',
 'PUT' => 10, 'GET' => 3,
 'DELETE' => 100 })

{
cinder_api_paste_ini {"filter:ratelimit/limits": value => "(POST, \"*\", .*, $limits['POST'], MINUTE);(POST, \"*/servers\", ^/servers, $limits['POST_SERVERS'], DAY);(PUT, \"*\", .*, $limits['PUT'], MINUTE);(GET, \"*changes-since*\", .*changes-since.*, 3, MINUTE);(DELETE, \"*\", .*, $limits['DELETE'], MINUTE)"}
  
}