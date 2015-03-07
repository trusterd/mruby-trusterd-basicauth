module HTTP2
  class Server
    class BasicAuth
      def initialize(file)
        @users = {}
        IO.open(IO.sysopen((file))) do |io|
          io.each do |line|
            params = line.chomp.split(":")
            @users[params[0]] = params[1]  if 1 < params.size
          end
        end
      end

      def auth(user, password)
        @users.key?(user) && @users[user] == password
      end
    end
  end
end
