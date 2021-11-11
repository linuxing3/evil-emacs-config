﻿;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; `现代基本配置'
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂

(use-package ob-go)
(use-package ob-rust)
(use-package ob-deno)

(defun +modern-org-config-h()
  ;; 设定`org的目录'
  (setq org-directory "~/org")
  ;; 设定`journal的目录'
  (defvar org-journal-base-dir nil
    "Netlify gridsome base directory")
  (setq org-journal-base-dir (workspace-path "awesome-hugo-blog/contents/journal"))
  ;; 设定`todo关键字'
  (setq org-todo-keywords '((sequence "[学习](s)" "[待办](t)" "[等待](w)" "|" "[完成](d)" "[取消](c)")
                            (sequence "[BUG](b)" "[新事件](i)" "[已知问题](k)" "[修改中](W)" "|" "[已修复](f)")))

  ;; 设定`hugo的目录'
  (setq org-hugo-base-dir (workspace-path "awesome-hugo-blog"))

  ;; 设定`agenda相关目录'
  (setq diary-file "~/org/diary")
  (setq org-agenda-diary-file "~/org/diary")
  
  (setq org-agenda-files (directory-files org-directory t "\\.agenda\\.org$" t))
  (add-to-list 'org-agenda-files (dropbox-path "works.agenda.org"))
  
  (setq org-archive-location "~/org/archived/%s_archive::"))

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; `现代Babel配置'
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
(defun +modern-babel-config-h()
  (setq org-src-preserve-indentation t  ; use native major-mode indentation
        org-src-tab-acts-natively t     ; we do this ourselves
        ;; You don't need my permission (just be careful, mkay?)
        org-confirm-babel-evaluate nil
        org-link-elisp-confirm-function nil
        ;; Show src buffer in popup, and don't monopolize the frame
        org-src-window-setup 'other-window
        ;; Our :lang common-lisp module uses sly, so...
        org-babel-lisp-eval-fn #'sly-eval)

  ;; I prefer C-c C-c over C-c ' (more consistent)
  (define-key org-src-mode-map (kbd "C-c C-c") #'org-edit-src-exit)

  (with-eval-after-load 'org
  (org-babel-do-load-languages
   (quote org-babel-load-languages)
   (quote ((emacs-lisp . t)
	       (java . t)
	       (dot . t)
	       (ditaa . t)
	       (plantuml . t)
	       (python . t)
	       (sed . t)
	       (awk . t)
	       (ledger . t)
           (C . t)
           (shell . t)
           (go . t)
           (rust . t)
           (deno . t)
	       (gnuplot . t)
	       (org . t)
	       (latex . t))))))

(defun +modern-appearance-config-h ()
  "Configures the UI for `org-mode'."
  (setq
   org-modules (quote (org-habit org-protocol org-man org-toc org-bookmark)))

  (setq org-ellipsis " ▼ "
        org-bullets-bullet-list '(" ○ " " ◆ ")
        org-tags-column -80)

  (setq org-todo-keyword-faces
        '(
          ("[学习]" . (:foreground "GoldenRod" :weight bold))
          ("[待办]" . (:foreground "IndianRed1" :weight bold))
          ("[等待]" . (:foreground "OrangeRed" :weight bold))
          ("[完成]" . (:foreground "coral" :weight bold))
          ("[取消]" . (:foreground "LimeGreen" :weight bold))
          ("[BUG]" . (:foreground "GoldenRod" :weight bold))
          ("[新事件]" . (:foreground "IndianRed1" :weight bold))
          ("[已知问题]" . (:foreground "OrangeRed" :weight bold))
          ("[修改中]" . (:foreground "coral" :weight bold))
          ("[已修复]" . (:foreground "LimeGreen" :weight bold))
          ))

  ;; FIXME: 如果启用自定义时间格式，将无法在时间内部进行修改
  ;; (setq-default org-display-custom-times t)
  ;; (setq org-time-stamp-custom-formats '("<%Y-%m-%d>" . "<%Y-%m-%d %H:%M>"))
   (setq org-indirect-buffer-display 'current-window
        org-eldoc-breadcrumb-separator " → "
        org-enforce-todo-dependencies t
        org-entities-user
        '(("flat"  "\\flat" nil "" "" "266D" "♭")
          ("sharp" "\\sharp" nil "" "" "266F" "♯"))
        org-fontify-done-headline t
        org-fontify-quote-and-verse-blocks t
        org-fontify-whole-heading-line t
        org-hide-leading-stars t
        org-image-actual-width nil
        org-imenu-depth 6
        org-priority-faces
        '((?A . error)
          (?B . warning)
          (?C . success))
        org-startup-indented t
        org-tags-column 0
        org-use-sub-superscripts '{}
        org-startup-folded nil)

  (setq org-reverse-note-order t)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-use-cache nil)
  (setq org-blank-before-new-entry nil)
  (setq org-refile-targets
        '((nil :maxlevel . 3)
          (org-agenda-files :maxlevel . 3))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil))

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; `启动配置'
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; (add-hook 'org-load-hook #'+modern-appearance-config-h)
;; (add-hook 'org-load-hook #'+modern-org-config-h)
;; (add-hook 'org-load-hook #'+modern-babel-config-h)
(+modern-org-config-h)
(+modern-appearance-config-h)
(+modern-babel-config-h)

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; `加载其他功能'
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
(require 'org+fancy-function)
(require 'org+fancy-app)

(provide 'module-org)
