**Canada eCoin**

https://github.com/validierungcc/canadaecoin-docker

https://canadaecoin.site/


Example docker-compose.yml

     ---
    services:
        canada-ecoin:
            container_name: canada-ecoin
            image: vfvalidierung/canada-ecoin
            restart: unless-stopped
            ports:
                - '34331:34331'
                - '127.0.0.1:34330:34330'
            volumes:
                - 'ecoin:/ecoin/.canadaecoin'
    volumes:
       ecoin:

**RPC Access**

    curl --user 'canadaecoinrpc:<password>' --data-binary '{"jsonrpc":"1.0","id":"curltext","method":"getblockchaininfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:34330
