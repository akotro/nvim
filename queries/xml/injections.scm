; SQL Injection
(
  (STag
    (Name) @name
  )
  (content
    (CharData) @injection.language
      (#eq? @name "WmsEntitySelectQuery")
      (#set! injection.language "sql")
      (#set! injection.combined)
      (#set! injection.include-children)
  )
)

