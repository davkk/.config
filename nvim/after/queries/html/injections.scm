;; extends

; [state]="myState$ | async"
(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "%[.*%]"))
  (quoted_attribute_value
    (attribute_value) @injection.content
        (#set! injection.language "angular")))

; (myEvent)="handle($event)"
(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "%(.*%)"))
  (quoted_attribute_value
    ((attribute_value) @injection.content
        (#set! injection.language "angular"))))

; *ngIf="blorgy"
(attribute
  ((attribute_name) @_name
   (#lua-match? @_name "^%*.*"))
  (quoted_attribute_value
    ((attribute_value) @injection.content
        (#set! injection.language "angular"))))

; {{ someBinding }}
(element
  ((text) @injection.content
   (#lua-match? @injection.content "%{%{.*%}%}")
   (#offset! @injection.content 0 2 0 -2)
   (#set! injection.language "angular")))
