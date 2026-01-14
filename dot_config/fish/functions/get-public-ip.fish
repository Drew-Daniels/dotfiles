function get-public-ip -d "Returns Public IP of Computer"
	command curl https://ipinfo.io/ip
end
