#lang racket/base

(define (make-tokenizer port)
  (define (next-token)
    (define rowdy-lexer
      (lexer
        [(eof) eof]
        ...))
    (rowdy-lexer port))
  next-token)
(provide make-tokenizer)
