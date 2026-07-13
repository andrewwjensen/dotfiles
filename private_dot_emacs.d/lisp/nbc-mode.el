;;
;; For syntax coloring and indenting of the Next Byte Codes (nbc) language for
;; controlling Lego Mindstorms NXT bricks.
;;

(defvar nbc-mode-hook nil)

(defvar nbc-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    map
    ) ;; let
  "Keymap for NBC major mode"
  ) ;; defvar nbc-mode-map

(add-to-list 'auto-mode-alist '("\\.nxc\\'" . nbc-mode))
(add-to-list 'auto-mode-alist '("\\.nbc\\'" . nbc-mode))

(setq nbc-keywords
  '(
    "asm"
    "break"
    "case"
    "const"
    "continue"
    "default"
    "else"
    "enum"
    "false"
    "for"
    "goto"
    "if"
    "inline"
    "priority"
    "repeat"
    "return"
    "safecall"
    "start"
    "static"
    "stop"
    "struct"
    "sub"
    "switch"
    "task"
    "true"
    "typedef"
    "until"
    "void"
    "while"
    )
  ) ;; setq nbc-keywords

(setq nbc-builtin-functions
  '(
    "abs"
    "Acquire"
    "ArrayBuild"
    "ArrayInit"
    "ArrayLen"
    "ArraySubset"
    "BranchComp"
    "BranchTest"
    "CurrentTick"
    "ExitTo"
    "ExitTo"
    "FirstTick"
    "Follows"
    "GetButtonModuleValue"
    "GetCommandModuleBytes"
    "GetCommandModuleValue"
    "GetCommModuleBytes"
    "GetCommModuleValue"
    "GetDisplayModuleBytes"
    "GetDisplayModuleValue"
    "GetInputModuleValue"
    "GetIOMapBytes"
    "GetIOMapBytesByID"
    "GetIOMapValue"
    "GetLastResponseInfo"
    "GetLoaderModuleValue"
    "GetLowSpeedModuleBytes"
    "GetLowSpeedModuleValue"
    "GetMemoryInfo"
    "GetOutputModuleValue"
    "GetSoundModuleValue"
    "GetUIModuleValue"
    "NumOut"
    "OnFwd"
    "OnRev"
    "SetSensorLowspeed"
    "SetSensorUS"
    "SetSensorMode"
    "SetSensorBoolean"
    "SensorType"
    "SetSensorBoolean"
    "SetSensorColorBlue"
    "SetSensorColorFull"
    "SetSensorColorGreen"
    "SetSensorColorNone"
    "SetSensorColorRed"
    "SetSensorEMeter"
    "SetSensorLight"
    "SetSensorSound"
    "SetSensorTemperature"
    "SetSensorTouch"
    "SetSensorType"
    "SetSensorUltrasonic"
    "ColorSensorRead"
    "ColorSensorRaw"
    "SensorValueRaw"
    "SensorValue"
    "SensorValueBool"
    "ReadSensorColorRaw"
    "SensorValue"
    "PlayTone"
    "Precedes"
    "Release"
    "ResetSleepTimer"
    "SetButtonModuleValue"
    "SetCommandModuleBytes"
    "SetCommandModuleValue"
    "SetCommModuleBytes"
    "SetCommModuleValue"
    "SetDisplayModuleBytes"
    "SetDisplayModuleValue"
    "SetInputModuleValue"
    "SetIOCtrlModuleValue"
    "SetIOMapBytes"
    "SetIOMapBytesByID"
    "SetIOMapValue"
    "SetIOMapValueByID"
    "SetLoaderModuleValue"
    "SetLowSpeedModuleBytes"
    "SetLowSpeedModuleValue"
    "SetOutputModuleValue"
    "SetSoundModuleValue"
    "SetUIModuleValue"
    "sign"
    "StartTask"
    "Stop"
    "StopAllTasks"
    "StopTask"
    "SysCall"
    "SysComputeCalibValue"
    "SysDatalogGetTimes"
    "SysDatalogWrite"
    "SysGetStartTick"
    "SysIOMapRead"
    "SysIOMapReadByID"
    "SysIOMapWrite"
    "SysIOMapWriteByID"
    "SysKeepAlive"
    "SysMemoryManager"
    "SysReadLastResponse"
    "SysReadSemData"
    "SysUpdateCalibCacheInfo"
    "SysWriteSemData"
    "voidGetIOMapValueByID"
    "Wait"
    "Yield"
    )
  ) ;; setq nbc-builtin-functions

(setq nbc-types
  '(
    "bool"
    "byte"
    "char"
    "float"
    "int"
    "long"
    "mutex"
    "short"
    "string"
    "unsigned"
    )
  ) ;; setq nbc-types

(defvar nbc-font-lock-keywords
  (list
   (cons (regexp-opt nbc-keywords 'words) font-lock-keyword-face)
   (cons (regexp-opt nbc-builtin-functions 'words) font-lock-builtin-face)
   (cons (regexp-opt nbc-types 'words) font-lock-type-face)
   '("\\<OUT[A-C]+\\>"   . font-lock-constant-face)
   '("\\<S[1-4]\\>"      . font-lock-constant-face)
   '("#\\(define\\|if\\|ifdef\\|ifndef\\|elif\\|endif\\|else\\|import\\|undef\\|download\\)\\>" . font-lock-preprocessor-face)
   ) ;; list
  ) ;; defvar nbc-font-lock-keywords

(defvar nbc-tab-width 4 "Width of a tab for NBC mode")

;; This is a very simple indentation function, and it is easy to confuse it
;; (like if you put multiple braces on a single line). However, for the normal
;; case, it seems to work well.
(defun nbc-indent-line ()
  "Indent current line as NBC code"
  (interactive)

  (save-excursion
    (beginning-of-line)

    (if (bobp)
        ;; Beginning of file is easy: no indent
        (indent-line-to 0)

      (let ((indented nil)
            (cur-indent 0))
        ;; Search backward for either:
        ;;    a) the beginning of the current block (opening brace)
        ;;    b) the end of the previous block (close brace)
        (save-excursion
          (if (re-search-backward "^[ \t]*}\\|^.*{[^{]*" nil t)
              (if (looking-at "^[ \t]*}")
                  ;; Found end of previous block; indent to the same level
                  (progn
                    (setq cur-indent (current-indentation))
                    (setq indented t)
                    )

                ;; else found start of this block; increase indent by tab width
                (setq cur-indent (+ (current-indentation) nbc-tab-width))
                (setq indented t)
                ) ;; if end of block
            ) ;; if re-search-backward (if found start or end of block)
          ) ;; save-excursion

        ;; Back to the line to be indented. Check if it is end of block.
        (if (looking-at "^[ \t]*}")
            (progn
              ;; End of block. Just use indent from start of block, meaning
              ;; decrease the current indent by the tab width.
              (setq cur-indent (- cur-indent nbc-tab-width))

              ;; Make sure we don't decrease indent to less than 0
              (if (< cur-indent 0)
                  (setq cur-indent 0)
                )
              ) ;; progn
          ) ;; if end of block

        (indent-line-to cur-indent)
        ) ;; let
      ) ;; if (bobp)
    ) ;; save-excursion

  ;; If point is inside leading whitespace, move to first non-whitespace char
  (let (point-save first-non-whitespace-char)
    (setq point-save (point))
    (save-excursion
      (back-to-indentation)
      (setq first-non-whitespace-char (point))
      )
    (if (< point-save first-non-whitespace-char)
        (goto-char first-non-whitespace-char)
      )
    ) ;; let
  ) ;; defun nbc-indent-line

(defvar nbc-mode-syntax-table
  (let ((nbc-st (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" nbc-st)
    (modify-syntax-entry ?* ". 23" nbc-st)
    (modify-syntax-entry ?\n "> b" nbc-st)
    (modify-syntax-entry ?_ "w" nbc-st)
    nbc-st
    )
  "Syntax table for nbc-mode"
  )

(defun nbc-mode ()
  "Major mode for nbc files"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table nbc-mode-syntax-table)
  (use-local-map nbc-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(nbc-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'nbc-indent-line)
  (setq major-mode 'nbc-mode)
  (setq mode-name "NBC")
  (run-hooks 'nbc-mode-hook)
  )

(provide 'nbc-mode)
