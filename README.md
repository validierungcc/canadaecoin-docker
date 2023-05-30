**Canada eCoin**

https://github.com/validierungcc/canada-ecoin-docker

https://canadaecoin.site/


Example docker-compose.yml

     ---
    version: '3.9'
    services:
        emark:
            container_name: canada-ecoin
            image: vfvalidierung/canada-ecoin
            restart: unless-stopped
            user: 1000:1000
            ports:
                - '4555:4555'
                - '127.0.0.1:4444:4444'
            volumes:
                - 'ecoin:/ecoin/.canadaecoin'
    volumes:
       ecoin:

**RPC Access**

    curl --user '<user>:<password>' --data-binary '{"jsonrpc":"1.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:34330
