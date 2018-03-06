USING: kernel sequences ;
IN: examples.sequences

: find-first ( seq pred? -- elem ) filter [ null ] [ first ] if-empty ; inline
