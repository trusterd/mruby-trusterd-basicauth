# mruby-trusterd-basicauth
## exmplae
```ruby
s.set_access_checker_cb {                                                        
                                                                                 
  if s.uri =~ /^\/auth\//                                                        
    basic = HTTP2::Server::BasicAuth.new({                                       
      :realm_name  => "Private Area",                                            
      :htpasswd    => "#{root_dir}/htdocs/auth/.htpasswd",                       
    })                                                                           
    basic.authn(s)                                                               
  end           
  
}                                                                                
```
