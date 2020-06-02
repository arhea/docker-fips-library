
```bash

docker image build -t fips-nginx:latest .

docker container run -it --rm --name=nginx-fips \
    -p 8443:443 \
    -v $(pwd)/test/ssl/fips.arhea.io.cert:/etc/nginx/ssl/fips.arhea.io.cert \
    -v $(pwd)/test/ssl/fips.arhea.io.key:/etc/nginx/ssl/fips.arhea.io.key \
    -v $(pwd)/test/default.conf:/etc/nginx/conf.d/default.conf \
    fips-nginx:latest

docker container rm nginx-fips

```
