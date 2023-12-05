; ; Sql Injection
; (local_declaration_statement
;   (variable_declaration
;     (predefined_type) @type
;     (variable_declarator
;       name: (identifier) @name
;       (equals_value_clause
;         (string_literal
;           (string_literal_fragment) @injection.content
;   (#eq? @type "string")
;   (#eq? @name "query")
;   (#set! injection.language "sql")
;   (#set! injection.combined)
;   (#set! injection.include-children)
;   )))))

; (local_declaration_statement
;   (variable_declaration
;     (implicit_type) @type
;     (variable_declarator
;       name: (identifier) @name
;       (equals_value_clause
;         (string_literal
;           (string_literal_fragment) @injection.content
;           (#set! injection.language "sql")
;           (#set! injection.combined)
;           (#set! injection.include-children)
;   (#eq? @name "query"))))))

; (local_declaration_statement
;   (variable_declaration
;     (predefined_type) @type
;     (variable_declarator
;       name: (identifier) @name
;       (equals_value_clause
;         (interpolated_string_expression
;           (interpolated_string_text) @injection.content
;   (#eq? @type "string")
;   (#eq? @name "query")
;   (#set! injection.language "sql")
;   (#set! injection.combined)
;   (#set! injection.include-children)
;   )))))

; (local_declaration_statement
;   (variable_declaration
;     (implicit_type) @type
;     (variable_declarator
;       name: (identifier) @name
;       (equals_value_clause
;         (interpolated_string_expression
;           (interpolated_string_text) @injection.content
;           (#set! injection.language "sql")
;           (#set! injection.combined)
;           (#set! injection.include-children)
;   (#eq? @type "string")
;   (#eq? @name "query"))))))

; (local_declaration_statement
;   (variable_declaration
;     (predefined_type) @type
;     (variable_declarator
;       name: (identifier) @name
;       (equals_value_clause
;         (interpolated_string_expression
;           (interpolated_verbatim_string_text) @injection.content
;   (#eq? @type "string")
;   (#eq? @name "query")
;   (#set! injection.language "sql")
;   (#set! injection.combined)
;   (#set! injection.include-children)
;   )))))

; (local_declaration_statement
;   (variable_declaration
;     (implicit_type) @type
;     (variable_declarator
;       name: (identifier) @name
;       (equals_value_clause
;         (interpolated_string_expression
;           (interpolated_verbatim_string_text) @injection.content
;           (#set! injection.language "sql")
;           (#set! injection.combined)
;           (#set! injection.include-children)
;   (#eq? @type "string")
;   (#eq? @name "query"))))))

; (expression_statement
;   (assignment_expression
;     left: (identifier) @name
;     right: (interpolated_string_expression
;             (interpolated_verbatim_string_text) @injection.content
;           (#set! injection.language "sql")
;           (#set! injection.combined)
;           (#set! injection.include-children)
;   (#eq? @name "query"))))
