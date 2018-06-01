#lang rowdy

require "api-router"

; returning a string literal tells Thingy to just render the string
GET /hello "Hello, World!"

; delegate to some other router
* /api/* api-router

; define a custom handler for arbitrary slugs, with some constraints
GET /:slug page-by-slug
  ; constrain slug to any string that is not "greet" or "forbidden".
  slug != "greet", "forbidden"
  ; custom route constraint called valid-slug?
  valid-slug? slug

; sets up conventional CRUD routes for /foo/...
resource foo
