#lang ragg

router: route-defn*


resource-defn: RESOURCE-NAME RESOURCE-CONSTRAINT*


route-defn: http-method-list route handler (NEWLINE [constraint])*

http-method-list: ["GET" | "POST" | "PUT" | "PATCH" | "DELETE"]+

route: (route-var | route-literal | route-pattern)+

; URL/path part of a route definition
route-var: ROUTE-VARNAME
route-literal: ROUTE-LITERAL
route-pattern: ROUTE-PATTERN


; dynamic or static handler for a given route
handler: IDENT | STRING


; arbitrary constraints on route params
constraint: IDENT (constraint-var | STRING)*
constraint-var: ROUTE-VARNAME


