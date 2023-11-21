; SQL Injection
(element
  (STag
    (Name) @tag-name)
    (content
      (CharData) @injection-content
      (#set! injection.language "sql")
      (#set! injection.combined)
      (#set! injection.include-children)
        (#eq? @tag-name "WmsEntitySelectQuery")))
