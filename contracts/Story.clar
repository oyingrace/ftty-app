;; ------------------------------------------------------------
;; ONE WORD STORY – Clarity 4 Contract
;; Users can add ONE WORD at a time.
;; Each entry is saved with:
;;  - the word
;;  - the sender (converted to ASCII text)
;;  - the block timestamp (Clarity 4 feature)
;; ------------------------------------------------------------

;; Data store for the story – an increasing list of entries
(define-data-var story (list 200 { 
    word: (string-ascii 32),
    sender: (string-ascii 256),
    timestamp: uint
}) 

;; initial empty list
    (list)
)

;; ------------------------------------------------------------
;; HELPER: Convert principal → ASCII string
;; New Clarity 4 feature allows converting values to readable text.
;; ------------------------------------------------------------
(define-read-only (principal-to-string (p principal))
    (to-utf8 p) ;; Clarity 4 built-in for conversion
)

;; ------------------------------------------------------------
;; PUBLIC FUNCTION: Add a single word to the story
;; Users call this directly.
;; Uses Clarity 4 timestamp and ASCII principal conversion.
;; ------------------------------------------------------------
(define-public (add-word (word (string-ascii 32)))
    (let (
            (sender tx-sender)
            (sender-text (principal-to-string sender))
            (time block-header-timestamp)
         )
         ;; Append new entry to story
        (begin
            (var-set story
                (append (var-get story)
                    (list { 
                        word: word,
                        sender: sender-text,
                        timestamp: time
                    })
                )
            )
            (ok { added: word, by: sender-text, at: time })
        )
    )
)