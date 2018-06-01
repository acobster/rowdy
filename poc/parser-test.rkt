#lang racket/base

(require rowdy/poc/parser
         ragg/support
         rackunit)

; custom assertion helper to check whether some list of tokens
; compiles to a given datum
(define (check-route->datum? syntax datum)
  (check-equal?
    (syntax->datum
      (parse syntax))
    datum))

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
       #f                        ; <-- I'd like to get rid of this
       (constraint
         "!="
         (constraint-var "slug")
         "greet"
         "grrrr"))))

