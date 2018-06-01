#lang ragg

; top-level rowdy expression
router: (route-defn | resource-defn | expression)*


resource-defn: RESOURCE-NAME RESOURCE-CONSTRAINT*


; route definition
route-defn: http-method-list route handler (/NEWLINE [constraint])*

http-method-list: ["GET" | "POST" | "PUT" | "PATCH" | "DELETE"]+
                | ["ANY" | "UPSERT"]

route: (route-var | route-literal | route-pattern)+

; URL/path part of a route definition
route-var: ROUTE-VARNAME
route-literal: ROUTE-LITERAL
route-pattern: ROUTE-PATTERN


; dynamic or static handler for a given route
handler: IDENT | STRING | interpolation

interpolation: (string-segment | embedded-var)+

string-segment: STRING-SEGMENT
embedded-var: EMBEDDED-VAR


; arbitrary constraints on route params
constraint: IDENT (constraint-var | STRING)*
constraint-var: ROUTE-VARNAME


; command
expression: require
require: KEY-REQUIRE STRING
