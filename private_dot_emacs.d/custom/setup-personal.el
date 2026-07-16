;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Package includes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

(use-package lua-mode)

(require 'dired-x) ; load shortcut C-x C-j (dired-jump)
(require 'nbc-mode)
(require 'tup-mode)
(require 'eldoc)
(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 4))
(add-hook 'graphviz-dot-mode-hook 'company-mode)

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; Trigger actions from any prompt
   ("M-." . embark-dwim)))      ;; "Do What I Mean" contextual action

;; Download yaml-mode.el from: https://github.com/yoshiki/yaml-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; Allow editing of binary .plist files.
(add-to-list 'jka-compr-compression-info-list
             ["\\.plist$"
              nil
              "cat"
              nil
              "converting binary plist to text XML"
              "plutil"
              ("-convert" "xml1" "-o" "-" "-")
              nil nil "bplist"])
(jka-compr-update)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Keymap definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar ctrl-z-keymap (make-keymap))
(global-set-key [(control z)] ctrl-z-keymap)
;; Eval the following if you want to restore default action for Ctrl-Z
;;(global-set-key [(control z)] 'suspend-emacs)

(global-set-key [(control z) (control z)] 'bury-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (display-graphic-p)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super))

(global-set-key [(control a)] 'beginning-of-line++)
(global-set-key [(control c) ?\;] 'comment-region)
(global-set-key [(control c) ?c] 'compile)
(global-set-key [(control c) ?e] 'make-file-executable)
(global-set-key [(control c) ?v] 'set-variable)
(global-set-key [(control c) ?w] 'make-file-writable)
(global-set-key [(control c) ?x] 'make-file-executable)
(global-set-key [(control r)] 'isearch-backward-regexp)
(global-set-key [(control s)] 'isearch-forward-regexp)
(global-set-key [(control w)] 'backward-kill-word) ;; Make C-w consistent with most shells
(global-set-key [(control x) (control c)] 'ask-then-exit)
(global-set-key [(control x) (control d)] 'c-ifdef-out-region)
(global-set-key [(control x) (control meta f)] 'find-file)
(global-set-key [(control x) (control k)] 'kill-region)
(global-set-key [(control x) ?\\] 'my-backslash-region)
(global-set-key [(control x) ?c] 'toggle-case-fold-search)
(global-set-key [(control x) ?l] 'goto-line)
(global-set-key [(control x) ?m] kmacro-keymap)
(global-set-key [(control z) (control o)] 'oid-renumber)
(global-set-key [(control z) (control u)] 'uniquify-all-lines-region)
(global-set-key [(control z) (control z)] 'bury-buffer)
(global-set-key [(control z) (control z)] 'bury-buffer)
(global-set-key [(meta n)] 'next-error)
(global-set-key [(meta p)] 'previous-error)
(global-set-key [(meta control g)] 'ag)
(global-set-key [(meta control y)] 'untabify)
(global-set-key [(super t)] 'transpose-words)

;; In case using a keyboard with no Alt or Esc, must be able
;; to enter Emacs commands...
(global-set-key [(control c) (control m)] 'execute-extended-command)

;; Function key bindings
(global-set-key [f1]          'reload-file)
(global-set-key [(meta  f1)]  'ps-print-buffer)
(global-set-key [(super f1)]  'ps-print-buffer)
(global-set-key [f2]          'sort-lines)
(global-set-key [(meta  f2)]  'sort-fields)
(global-set-key [(super f2)]  'sort-fields)
(global-set-key [f3]          'ispell-buffer)
(global-set-key [(meta  f3)]  'set-c-basic-offset)
(global-set-key [(super f3)]  'set-c-basic-offset)
(global-set-key [f4]          'set-tab-width)
(global-set-key [(meta  f4)]  'c++-mode)
(global-set-key [(super f4)]  'c++-mode)
(global-set-key [f5]          'align-regexp)
(global-set-key [(meta  f5)]  'call-last-kbd-macro)
(global-set-key [(super f5)]  'call-last-kbd-macro)
(global-set-key [(meta  f6)]  'remove-trailing-whitespace)
(global-set-key [(super f6)]  'remove-trailing-whitespace)
(global-set-key [f7]          'query-replace)
(global-set-key [(meta  f7)]  'replace-ws-with-nl)
(global-set-key [(super f7)]  'replace-ws-with-nl)
(global-set-key [f8]          'query-replace-regexp)
(global-set-key [f9]          'c-backslash-region)
(global-set-key [(meta  f9)]  'set-unix-file-coding)
(global-set-key [(super f9)]  'set-unix-file-coding)
(global-set-key [f10]         'renumber-regex)
(global-set-key [(meta  f10)] 'renumber-regex-easy)
(global-set-key [(super f10)] 'renumber-regex-easy)
(global-set-key [f11]         'sort-words)
(global-set-key [(meta  f11)] 'linum-mode)
(global-set-key [(super f11)] 'linum-mode)
(global-set-key [f12]         'toggle-truncate-lines)
(global-set-key [(meta  f12)] 'top-level)
(global-set-key [(super f12)] 'top-level)
(global-set-key [delete]      'delete-char)
(global-set-key [f13]         'overwrite-mode)

;;; redefine the Mac del key |X> called select by X
(global-set-key [select] 'delete-char)

;;; for a Mac, insert is shift-help, but X reads the shift
(global-set-key [(shift insert)] 'overwrite-mode)

;; Emacs 24.1 changed C-y in isearch mode to yank; restore old binding
(if (or (> emacs-major-version 24)
        (and (= emacs-major-version 24)
             (> emacs-minor-version 0)))
    (define-key isearch-mode-map (kbd "C-y") 'isearch-yank-line))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        C and C++ modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Make all .h files open in C++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(defconst andy-c-indent-style
  '((c-basic-offset . 4)
    (c-offsets-alist
     . ((substatement-open     . 0)
        (inline-open           . 0)
        (label                 . 0)
        (case-label            . 0)
        (innamespace           . 0)
        )))
  "Andy's C indentation style")

(defconst dss-c-indent-style
  '((c-basic-offset . 4)
    (c-offsets-alist
     . (
        (case-label . + )
        (inclass . ++)
        (inline-open . 0 )
        (label . 0 )
        (statement-block-intro . +)
        (statement-cont . +)
        (substatement-label . 0)
        (substatement-open . 0 )
        )))
  "DSS C indentation style")

(defun beginning-of-line++ ()
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

(defun my-c-lineup-inclass (langelem)
  (let ((inclass (assoc 'inclass c-syntactic-context)))
    (save-excursion
      (goto-char (c-langelem-pos inclass))
      (if (looking-at "{")
          ;; The { must be on the line after the "struct" or "class" keyword
          (c-beginning-of-defun))
      (if (or (looking-at "struct")
              (looking-at "typedef struct"))
          '+
        '++))))

(c-add-style "andy" andy-c-indent-style)
(c-add-style "dss" dss-c-indent-style)

(defun my-c-mode-common-hook ()
  (interactive)
  (c-add-style "andy" andy-c-indent-style)
  (c-add-style "dss" dss-c-indent-style)
  (require 'compile)
  ;;(setq compile-command "cd $MKB_BASEDIR; PATH=/usr/local/bin:/bin:/usr/bin tup -k")
  (setq compile-command "git exec mvn -B clean package")
  (c-set-offset 'access-label '-)
  (c-set-offset 'inclass 'my-c-lineup-inclass)
  (c-set-style "andy")
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Emacsclient server
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (or (eq window-system 'x)
        (eq window-system 'ns))
    (progn
      ;; Allow emacsclient to connect and display files...
      (server-start)
      ;; ... but get rid of annoying "still has clients" confirmation on kill
      ;;(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
      ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    Disabled functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(put 'narrow-to-region 'disabled nil)
(put 'scroll-left      'disabled nil)
(put 'set-goal-column  'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    Function definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ask-then-exit ()
  "Ask if user wants to exit emacs before actually exiting."
  (interactive)
  (if (y-or-n-p "Exit emacs? ")
      (save-buffers-kill-emacs)
    (message "")))

(defun c-ifdef-out-region (start end extended)
  "Put #if 0 ... #endif around text in region.
Arg means add else clause. If register 'D' contains anything,
its contents are used as the arg of #if instead of ' 0'. Note that
no space is inserted so that if register 'D' contains 'def WIN32' you
will get '#ifdef WIN32'."
  (interactive "r\nP")
  (save-excursion
    (let* ((else nil)
           (tag (get-register ?D))
           (space " ")
           (comment tag))
      (if (or (null tag) (= (length tag) 0))
          (progn
            (setq tag nil)
            (setq comment "")))

      ;; If tag starts with "def " then remove it from the comment we insert
      (if (string-match "^def " comment)
          (setq comment (substring comment 4)))

      ;; If comment starts with space, don't insert our own
      (if (and comment (= ?\  (string-to-char comment)))
          (setq space ""))

      ;; Put the #else and #endif at the end of region. But if end is not
      ;; at the beginning of a line, put it after the current line.
      (goto-char end)
      (if (not (looking-at "^"))
          (progn
            (end-of-line)
            ;; Handle the case we are at the end of a file with no newline
            (if (looking-at "\n")
                (forward-char)
              (insert "\n"))))

      ;; Some checking needed to handle beginning of buffer
      (if (= (point) (point-min))
          (progn
            (insert "\n")
            (backward-char))
        ;; Want to do it this way if not at beginning of buffer so point is
        ;; restored properly if at the beginning of a line after leaving
        ;; save-excursion block.
        (backward-char)
        (insert "\n"))

      (if extended (if tag (insert (concat "#else /*" space comment " */\n"))
                     (insert "#else\n")))
      (insert "#endif")
      ;;(if tag (insert (concat " /*" space comment " */")))
      (goto-char start)
      (beginning-of-line)
      (if tag
          (insert (concat "#if" tag "\n"))
        (insert "#if 0\n")
        )
      )
    )
  )

(defun make-file-executable ()
  "Change file mode so it is executable, if possible."
  (interactive)
  (set-file-modes (buffer-file-name)
                  (logior (octstring-to-number "0500")
                          (file-modes (buffer-file-name))))
  (message "file is now executable"))

(defun make-file-writable ()
  "Change file mode so it is writable, if possible."
  (interactive)
  (set-file-modes (buffer-file-name)
                  (logior (octstring-to-number "0200")
                          (file-modes (buffer-file-name))))
  (message "file is now writable"))

(defcustom my-backslash-align t
  "*If non-nil, `my-backslash-region' will align backslashes."
  :type 'boolean
  :group 'sh)

(defcustom my-backslash-column 48
  "*Column in which `my-backslash-region' inserts backslashes."
  :type 'integer
  :group 'sh)

(defun my-backslash-append (column)
  (end-of-line)
  ;; Note that "\\\\" is needed to get one backslash.
  (if (= (preceding-char) ?\\)
      (progn (forward-char -1)
             (delete-horizontal-space)
             (indent-to column (if my-backslash-align nil 1)))
    (indent-to column (if my-backslash-align nil 1))
    (insert "\\")))

(defun my-backslash-delete ()
  (end-of-line)
  (or (bolp)
      (progn
       (forward-char -1)
       (if (looking-at "\\\\")
           (delete-region (1+ (point))
                          (progn (skip-chars-backward " \t") (point)))))))

;; Backslashification.  Stolen from make-mode.el.
(defun my-backslash-region (from to delete-flag)
  "Insert, align, or delete end-of-line backslashes on the lines in the region.
With no argument, inserts backslashes and aligns existing backslashes.
With an argument, deletes the backslashes.

This function does not modify the last line of the region if the region ends
right at the start of the following line; it does not modify blank lines
at the start of the region.  So you can put the region around an entire
shell command and conveniently use this command."
  (interactive "r\nP")
  (save-excursion
    (goto-char from)
    (let ((column my-backslash-column)
          (endmark (make-marker)))
      (move-marker endmark to)
      ;; Compute the smallest column number past the ends of all the lines.
      (if my-backslash-align
         (progn
           (if (not delete-flag)
               (while (< (point) to)
                 (end-of-line)
                 (if (= (preceding-char) ?\\)
                     (progn (forward-char -1)
                            (skip-chars-backward " \t")))
                 (setq column (max column (1+ (current-column))))
                 (forward-line 1)))
           ;; Adjust upward to a tab column, if that doesn't push
           ;; past the margin.
           (if (> (% column tab-width) 0)
               (let ((adjusted (* (/ (+ column tab-width -1) tab-width)
                                  tab-width)))
                 (if (< adjusted (window-width))
                     (setq column adjusted))))))
      ;; Don't modify blank lines at start of region.
      (goto-char from)
      (while (and (< (point) endmark) (eolp))
        (forward-line 1))
      ;; Add or remove backslashes on all the lines.
      (while (and (< (point) endmark)
                  ;; Don't backslashify the last line
                  ;; if the region ends right at the start of the next line.
                  (save-excursion
                    (forward-line 1)
                    (< (point) endmark)))
        (if (not delete-flag)
            (my-backslash-append column)
          (my-backslash-delete))
        (forward-line 1))
      (move-marker endmark nil))))

(defun octstring-to-number (str)
  "Convert a octal number in a string to an integer."
  (let ((x 0)
        c)
    (if (not (string-match "^[0-7]+$" str))
        (error "invalid oct string"))
    (while (> (length str) 0)
      (setq c (- (string-to-char (substring str 0 1)) 48))
      (setq str (substring str 1))
      (setq x (+ (* x 8) c)))
    x))

(defun reload-file ()
  (interactive)
  (if (not (buffer-modified-p))
      (let ((save-pos (point)))
        (revert-buffer nil t)
        (goto-char save-pos)
        )
    (message "Buffer has been modified; not reverting.")
    (beep)
    )
  )

(defun remove-trailing-whitespace ()
  "Remove trailing spaces and tabs from all lines in current buffer."
  (interactive)
  ;; Passing nil as START and END operates on the whole buffer
  (delete-trailing-whitespace)
  )

(defvar renumber-regex
  "^\\([0-9]+\\)"
  "Default regular expression to use when calling renumber-regex.")

(defvar renumber-subexp
  1
  "Default sub-expression number to replace when calling renumber-regex.")

(defun renumber-regex (begin end regex &optional initial subexp)
  "Renumber items in region. Each line in the region matching regex
has the nth sub-expression (specified by variable
renumber-subexp) replaced with a sequence number starting with
the number found in the first matching line.

Optional arg initial is the value to insert in the first match.

Optional arg subexp is an integer n, meaning replace the nth
sub-expression instead of the one defined by variable
renumber-subexp. Updates renumber-subexp to this value so it is
the default on the next call."
  (interactive (let ((string (read-string "Regex to match for renumbering: " renumber-regex)))
                 (list (region-beginning)
                       (region-end)
                       string)))
  (save-excursion
    (save-restriction
      (cl-block 'body
        (let ((count nil)
              num
              substring) ;; the current number to insert

          ;; Set default for next invocation
          (setq renumber-regex regex)

          (if (not (null current-prefix-arg))
              ;; User specified a prefix, so prompt for subexp
              (progn
                (setq subexp (read-number "Which sub-expression to replace: " renumber-subexp))
                (setq renumber-subexp subexp)
                ))

          ;; Use default if none specified
          (if (null subexp)
              (setq subexp renumber-subexp))

          (goto-char begin)

          ;; First, find the first match
          (re-search-forward regex end t)
          (setq substring (match-string subexp))
          (if (null substring)
              ;; Did not find a match, or the substring does not exist. The
              ;; only reason it would not exist is if the subexp number is
              ;; larger than the number of sub-expressions defined in
              ;; regex. This would be a user input error, and nothing will
              ;; ever be done in that case, so abort.
              (progn
                (message "No match for regular expression/sub-expression number")
                (beep)
                (cl-return-from 'body)))

          (if (not (null current-prefix-arg))
              ;; User specified a prefix, so prompt for initial. Use the matched
              ;; value as the default in the prompt.
              (progn
                ;; Get the subexp value as an integer
                (progn
                  (goto-char (match-end subexp))
                  (setq intitial 1)
                  (if (not (string= "" substring))
                      (setq initial substring))
                  (setq initial (read-string "Starting value to insert: " initial))
                  ;; Try to parse as an integer
                  (setq num (string-to-number initial))
                  (if (or (/= 0 num) (string= initial (prin1-to-string num t)))
                      ;; It's a valid integer
                      (setq initial num)
                      )
                  )
                )
            )

          (narrow-to-region begin end)
          (goto-char (point-min))
          (while (re-search-forward regex nil t)
            (setq substring (match-string subexp))
            (if (null count)
                ;; First match found, set up initial value for count
                (if (not (null initial))
                    (setq count initial)

                  (if (string= "" substring)
                      ;; The match expression was empty, so start count at initial.
                      (setq count initial)

                    ;; The match expression is not empty, so use it as
                    ;; the starting point for count
                    (setq num (string-to-number substring))
                    (if (and (= 0 num) (not (string= substring (prin1-to-string num t))))
                        (setq count substring)
                      (setq count num)
                      )
                    )
                  )
              )

            (replace-match (prin1-to-string count t) nil t nil subexp)
            (setq count (+ 1 count))
            )
          )
        )
      )
    )
  )

(defun renumber-regex-easy (regex)
  "Renumber items in region. Each line matching given regex has the immediately
following number replaced with a sequence number starting with the number found
in the first matching line."
  (interactive "sRegex preceding numbers: ")
  (renumber-regex (concat regex "\\([0-9]*\\)"))
  )

(defun replace-ws-with-nl (re)
  "Replace all occurrences of consecutive whitespace with a single newline in current buffer."
  (interactive "P") ; P = raw prefix (nil if no prefix)
  (save-excursion
    (if (null re)
        (setq re "[ \t]+")
      (setq re (read-string "Enter regexp to replace with newlines: "))
      )
    (goto-char (point-min))
    (while (re-search-forward re nil t)
      (replace-match "\n"))
    )
  )

(defun set-c-basic-offset (offset)
  "In C-mode, set variable c-basic-offset."
  (interactive "nNew c-basic-offset: ")
  (setq c-basic-offset offset)
  (message (concat "c-basic-offset is now " (prin1-to-string c-basic-offset)))
  )

(defun set-tab-width (&optional width)
  "Set the tab width; if no param, set to 4."
  (interactive "P")
  (if width
      (progn
        (message (concat "Setting tab width to " (prin1-to-string width) "."))
        (setq tab-width width)
        )
    (message "Setting tab width to 4.")
    (setq tab-width 4)
    )
  ;; To be sure the effects of the new tab width is immediately visible
  (redraw-frame (selected-frame))
  )

(defun set-unix-file-coding (extended)
  (interactive "P")
  (if (null extended)
      (set-buffer-file-coding-system (quote undecided-unix) nil)
    (set-buffer-file-coding-system)
    )
  )

(defun sort-words (reverse beg end)
  "Sort words in region alphabetically, in REVERSE if negative.
    Prefixed with negative \\[universal-argument], sorts in reverse.

    The variable `sort-fold-case' determines whether alphabetic case
    affects the sort order.

    See `sort-regexp-fields'."
  (interactive "*P\nr")
  (sort-regexp-fields reverse "\\S-+" "\\&" beg end))

(defun uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((lines) (end (copy-marker end)))
      (goto-char start)
      (while (and (< (point) (marker-position end))
                  (not (eobp)))
        (let ((line (buffer-substring-no-properties
                     (line-beginning-position) (line-end-position))))
          (if (member line lines)
              (delete-region (point) (progn (forward-line 1) (point)))
            (push line lines)
            (forward-line 1)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;            Miscellaneous
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bar-mode)
(modify-syntax-entry ?_ "_")
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(setq tramp-terminal-type "tramp")

(when (string= system-type "darwin")       
  (setq dired-use-ls-dired nil))

(setq sh-basic-offset 2
      sh-indentation 2
      indent-tabs-mode nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;        Desktop (restoration of previously open files)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(desktop-save-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'setup-personal)
