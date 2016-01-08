## Prox

```shell
$ prox
Usage: prox (-p|--port PORT) (-x|--redir-url ARG) (-y|--redir-port ARG)
            [-v|--verbose] [-f|--fast]
  mini reverse proxy server. support websocket with --fast. Not yet https but
  should be trivial to implement
```

example: 

```shell
prox -p 3000 -x localhost -y 8081 -v
```



some practical doc:

 - http://haddock.stackage.org/lts-4.0/http-reverse-proxy-0.4.3/Network-HTTP-ReverseProxy.html
 - http://haddock.stackage.org/lts-3.18/optparse-applicative-0.11.0.2/Options-Applicative-Builder.html