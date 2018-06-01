#lang racket/base

(require rowdy/tokenizer
         rackunit)

(check-equal?
  (read (open-input-string "#f"))
  #f)
