#lang racket/base

(require rowdy/parser
         ragg/support
         rackunit)

; custom assertion helper to check whether some list of tokens
; compiles to a given datum
(define (check-route->datum? syntax datum)
  (check-equal?
    (syntax->datum
      (parse syntax))
    datum))


; require "api-router"
(check-route->datum?
  (list
    (token 'KEY-REQUIRE)
    (token 'STRING "api-router"))
  '(router
     (expression
       (require #f "api-router"))))


; GET /hello "Hello, World!"
(check-route->datum?
  (list
    "GET"
    "POST"
    (token 'ROUTE-LITERAL "hello")
    (token 'STRING "Hello, World!"))
  '(router
     (route-defn
       (http-method-list "GET" "POST")
       (route
         (route-literal "hello"))
       (handler "Hello, World!"))))

; ANY /post/:id (post-handler id)
(check-route->datum?
  (list
    "ANY"
    (token 'ROUTE-LITERAL "post")
    (token 'ROUTE-VARNAME "id")
    (token 'IDENT "post-handler"))
  '(router
     (route-defn
       (http-method-list "ANY")
       (route
         (route-literal "post")
         (route-var "id"))
       (handler "post-handler"))))

; GET /:slug page-by-slug
;  slug != "greet", "grrrr"
(check-route->datum?
  (list
    "GET"
    (token 'ROUTE-VARNAME "slug")
    (token 'IDENT "page-by-slug")

    (token 'NEWLINE)
    (token 'IDENT "!=")
    (token 'ROUTE-VARNAME "slug")
    (token 'STRING "greet")
    (token 'STRING "grrrr"))
  '(router
     (route-defn
       (http-method-list "GET")
       (route
         (route-var "slug"))
       (handler "page-by-slug")
       #f
       (constraint
         "!="
         (constraint-var "slug")
         "greet"
         "grrrr"))))

; resource foo
(check-route->datum?
  (list
    (token 'RESOURCE-NAME "foo"))
  '(router
     (resource-defn "foo")))

; handle multiple routes:
; POST /foo foo-handler
; POST /bar bar-handler
(check-route->datum?
  (list
    "POST"
    (token 'ROUTE-LITERAL "foo")
    (token 'IDENT "foo-handler")

    "POST"
    (token 'ROUTE-LITERAL "bar")
    (token 'IDENT "bar-handler"))
  '(router
     (route-defn
       (http-method-list "POST")
       (route
         (route-literal "foo"))
       (handler "foo-handler"))
     (route-defn
       (http-method-list "POST")
       (route
         (route-literal "bar"))
       (handler "bar-handler"))))

; GET /greet/:greeting/:name "${greeting}, ${name}!"
(check-route->datum?
  (list
    "GET"
    (token 'ROUTE-LITERAL "greet")
    (token 'ROUTE-VARNAME "greeting")
    (token 'ROUTE-VARNAME "name")

    (token 'EMBEDDED-VAR "greeting")
    (token 'STRING-SEGMENT ", ")
    (token 'EMBEDDED-VAR "name")
    (token 'STRING-SEGMENT "!"))
  '(router
     (route-defn
       (http-method-list "GET")
       (route
         (route-literal "greet")
         (route-var "greeting")
         (route-var "name"))
       (handler
         (interpolation
           (embedded-var "greeting")
           (string-segment ", ")
           (embedded-var "name")
           (string-segment "!"))))))

