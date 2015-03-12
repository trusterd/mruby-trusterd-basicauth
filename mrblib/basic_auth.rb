module HTTP2
  class Server
    class BasicAuth
      def initialize(config)
        @config = {
          :realm_name => "Private page",
        }.merge(config)
        raise ArgumentError  unless @config.key?(:htpasswd)

        @users = Htpasswd.load(@config[:htpasswd])
      end

      def authn(s)
        if s.r.headers_in["authorization"].nil?
          s.r.headers_out["www-authenticate"] = %Q(Basic realm="#{@config[:realm_name]}")
          s.set_status 401
          return false
        end

        auth = s.r.headers_in["authorization"]
        params = auth.split(" ")[1].unpack("m")[0].split(":")
        if params[0] == "" || params[1] == "" || !@users.key?(params[0])
          s.r.headers_out["www-authenticate"] = %Q(Basic realm="#{@config[:realm_name]}")
          s.set_status 401
          return false
        end

        pwd = Crypt::APRMD5.encrypt(params[1], @users[params[0]]) || ""
        if pwd == "" || @users[params[0]] != pwd
          s.r.headers_out["www-authenticate"] = %Q(Basic realm="#{@config[:realm_name]}")
          s.set_status 401
          return false
        end
        return true
      end

      def self.parse(s)
         return nil  if s.nil? || s == "" || s[0] == "#"
         params = s.split(":", 3)
         return nil  if params.length < 2

         {:username => params[0], :password => params[1]}
       end
    end

    class Htpasswd
      def self.load(filename)
        users = {}
        IO.open(IO.sysopen((filename))) do |io|
          io.each do |line|
            user = Htpasswd.parse(line.chomp)
            users[user[:username]] = user[:password]  unless user.nil?
          end
        end
        users
      end

      def self.parse(s)
        return nil  if s.nil? || s == "" || s[0] == "#"
        params = s.split(":", 3)
        return nil  if params.length < 2

        {:username => params[0], :password => params[1]}
      end
    end
  end
end
