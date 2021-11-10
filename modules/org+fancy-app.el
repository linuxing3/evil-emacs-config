;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; 博客 blog
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; for Hugo

(use-package simple-httpd)
(use-package ox-hugo)

(defvar blog-hugo-process "Hugo Server"
  "Name of 'gridsome develop' process process")

(defun +modern-blog-hugo-find-dir ()
  "Open hugo blog files"
  (interactive)
  (find-file (workspace-path "awesome-hugo-blog/content/posts")))

(defun +modern-blog-hugo-deploy ()
  "Run gridsome cli and push changes upstream."
  (interactive)
  (with-dir org-hugo-base-dir
            ;; deploy to github for ci
            (shell-command "cd " org-hugo-base-dir)
            (shell-command "git add .")
            (--> (current-time-string)
                 (concat "git commit -m \"" it "\"")
                 (shell-command it))
            (shell-command "git push")))

(defun +modern-blog-hugo-start-server ()
  "Run gridsome server if not already running and open its webpage."
  (interactive)
  (with-dir org-hugo-base-dir
            (shell-command "cd " org-hugo-base-dir)
            (unless (get-process blog-hugo-process)
              (start-process blog-hugo-process nil "hugo" "server"))))

(defun +modern-blog-hugo-end-server ()
  "End gridsome server process if running."
  (interactive)
  (--when-let (get-process blog-hugo-process)
    (delete-process it)))

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; NOTE: 日志 Journal  ---- 已迁移到hugo
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
(defun +modern-org-journal-new-journal ()
  "Create the journal in a specific directory, then your can export ..."
  (interactive)
  (progn
	(setq journal-file-path (concat org-journal-base-dir "/" (format-time-string "%Y%m%d") ".org"))
    (if (file-exists-p journal-file-path)
        (find-file-other-window journal-file-path)
      (progn
        (find-file-other-window journal-file-path)
        (goto-char (point-min))
        (insert "---\n")
        (insert (concat "#+TITLE: Journal Entry\n"))
        (insert "#+AUTHOR: Xing Wenju\n")
        (insert (concat "#+DATE: " (format-time-string "%Y-%m-%d") "\n"))
        (insert "#+EXCERPT: org journal \n")
        (insert "---\n")))))

(defun commom--org-headers (file)
  "Return a draft org mode header string for a new article as FILE."
  (let ((datetimezone
         (concat
          (format-time-string "%Y-%m-%d"))))
    (concat
     "#+TITLE: " file
     "\n#+AUTHOR: "
     "\n#+DATE: " datetimezone
     "\n#+PUBLISHDATE: " datetimezone
     "\n#+EXCERPT: nil"
     "\n#+DRAFT: nil"
     "\n#+TAGS: nil, nil"
     "\n#+DESCRIPTION: Short description"
     "\n\n")))

(use-package org-journal
  :ensure t
  :defer t
  :init
  (add-to-list 'magic-mode-alist '(+org-journal-p . org-journal-mode))

  (defun +org-journal-p ()
    "Wrapper around `org-journal-is-journal' to lazy load `org-journal'."
    (when-let (buffer-file-name (buffer-file-name (buffer-base-buffer)))
      (if (or (featurep 'org-journal)
              (and (file-in-directory-p
                    buffer-file-name (expand-file-name org-journal-dir org-directory))
                   (require 'org-journal nil t)))
          (org-journal-is-journal))))

  (setq org-journal-dir (workspace-path "awesome-hugo-blog/contents/journal/")
        org-journal-cache-file (dropbox-path "org/journal/"))

  :config
  (setq magic-mode-alist (assq-delete-all 'org-journal-is-journal magic-mode-alist))

  (setq org-journal-carryover-items  "TODO=\"TODO\"|TODO=\"PROJ\"|TODO=\"STRT\"|TODO=\"WAIT\"|TODO=\"HOLD\""))

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; 番茄时钟
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
(use-package org-pomodoro
  :ensure t
  :config
  (with-eval-after-load 'org-pomodoro
    ;; prefer PulseAudio to ALSA in $current_year
    (setq org-pomodoro-audio-player (or (executable-find "paplay")
					                    org-pomodoro-audio-player))

    ;; configure pomodoro alerts to use growl or libnotify
    (alert-add-rule :category "org-pomodoro"
		            :style (cond (alert-growl-command
				                  'growl)
				                 (alert-notifier-command
				                  'notifier)
				                 (alert-libnotify-command
				                  'libnotify)
				                 (alert-default-style)))))

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; 信息聚合
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
(use-package elfeed-org
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list
			                  (concat org-directory "/elfeed1.org")
			                  (concat org-directory "/elfeed2.org")))
  (setq elfeed-db-directory (concat org-directory "/elfeed/db/"))
  (setq elfeed-enclosure-default-dir (concat org-directory "/elfeed/enclosures/"))
  (setq elfeed-search-filter "@3-month-ago +unread")
  )

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; ✿ NOTE: 演示文稿
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
(use-package ox-reveal
  :init
  (setq org-reveal-root (dropbox-path "shared/ppt/reveal.js"))
  (setq org-reveal-postamble "Xing Wenju"))


;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; ✿ NOTE: Brain配置
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
(use-package org-brain
  :ensure t
  :init
  (setq org-brain-visualize-default-choices 'all
        org-brain-title-max-length 24
        org-brain-include-file-entries nil
        org-brain-file-entries-use-title nil)

  :config
  (cl-pushnew '("b" "Brain" plain (function org-brain-goto-end)
                "* %i%?" :empty-lines 1)
              org-capture-templates
              :key #'car :test #'equal))

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; (use-package org-noter :ensure t)
;; (use-package org-appear :ensure t)

(use-package org-download :ensure t)

;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂
;; ✿ NOTE: 发布网站
;; ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂ ✂

(use-package htmlize)

(defvar nico-website-html-head
  "<link href='http://fonts.googleapis.com/css?family=Libre+Baskerville:400,400italic' rel='stylesheet' type='text/css'>
<link rel='stylesheet' href='css/site.css' type='text/css'/>")

(defvar nico-website-html-blog-head
  "<link href='http://fonts.googleapis.com/css?family=Libre+Baskerville:400,400italic' rel='stylesheet' type='text/css'>
<link rel='stylesheet' href='../css/site.css' type='text/css'/>")

(defvar nico-website-html-preamble
  "<div class='nav'>
<ul>
<li><a href='/'>Home</a></li>
<li><a href='/blog/index.html'>Blog</a></li>
<li><a href='http://github.com/linuxing3'>GitHub</a></li>
<li><a href='http://twitter.com/linuxing3'>Twitter</a></li>
<li><a href='/contact.html'>Contact</a></li>
</ul>
</div>")

(defvar nico-website-html-postamble
  "<div class='footer'>
Copyright 2013 %a (%v HTML).<br>
Last updated %C. <br>
Built with %c.
</div>")

(use-package org
  :config
  (require 'ox-publish)
  (setq org-publish-project-alist
        '(
          ;; 将`emacs配置'发布到`OneDrive'
          ("emacs-config"
           :base-directory "~/.evil.emacs.d/"
           :base-extension "el\\|org"
           :recursive t
           :publishing-directory "~/OneDrive/config/emacs/scratch/"
           :publishing-function org-publish-attachment)

          ;; 关于`org-native-blog'的配置
          ;; 将`org'目录下org文件发布到网站根目录
          ("webroot"
           :base-directory "~/EnvSetup/org/"
           :base-extension "org"
           :publishing-directory "~/workspace/github.io/"
           :publishing-function org-html-publish-to-html
           :section-numbers nil
           :with-toc nil
           :html-head "
<link href='http://fonts.googleapis.com/css?family=Libre+Baskerville:400,400italic' rel='stylesheet' type='text/css'>
<link rel='stylesheet' href='assets/css/site.css' type='text/css'/>"
           :html-preamble "
<div class='nav'><ul>
<li><a href='/'>Home</a></li>
<li><a href='/blog/index.html'>Blog</a></li>
<li><a href='http://github.com/linuxing3'>GitHub</a></li>
<li><a href='http://twitter.com/linuxing3'>Twitter</a></li>
<li><a href='/contact.html'>Contact</a></li>
</ul>
</div>"
           ;; :html-preamble ,nico-website-html-preamble
           :html-postamble "
<div class='footer'>
Copyright 2013 %a (%v HTML).<br>
Last updated %C. <br>
Built with %c.
</div>"
           )

          ;; 将`org/journal'发布到网站的`blog'目录
          ("blog"
           :base-directory "~/OneDrive/org/journal/"
           :base-extension "org"
           :publishing-directory "~/workspace/github.io/blog/"
           :publishing-function org-html-publish-to-html
           :exclude "PrivatePage.org" ;; regexp
           :headline-levels 3
           :section-numbers nil
           :with-toc nil
           :section-numbers nil
           :with-toc nil
           :html-head "
<link href='http://fonts.googleapis.com/css?family=Libre+Baskerville:400,400italic' rel='stylesheet' type='text/css'>
<link rel='stylesheet' href='../assets/css/site.css' type='text/css'/>"
           :html-head-extra "
<link rel=\"alternate\" type=\"application/rss+xml\" href=\"http://linuxing3.github.io/blog.xml\" title=\"RSS feed\">"
           :html-preamble "
<div class='nav'><ul>
<li><a href='/'>Home</a></li>
<li><a href='/blog/index.html'>Blog</a></li>
<li><a href='https://github.com/linuxing3'>GitHub</a></li>
<li><a href='https://twitter.com/linuxing3'>Twitter</a></li>
<li><a href='/contact.html'>Contact</a></li>
</ul>
</div>"
           :html-postamble "
<div class='footer'>
Copyright 2013 %a (%v HTML).<br>
Last updated %C. <br>
Built with %c.
</div>"
           ) ;; end of blog configuration

          ;; 将`assets'发布到`网站根目录'
          ("images"
           :base-directory "~/OneDrive/org/assets/images/"
           :base-extension "jpg\\|jpeg\\|gif\\|png"
           :recursive t
           :publishing-directory "~/workspace/github.io/assets/images/"
           :publishing-function org-publish-attachment)


          ("attach"
           :base-directory "~/OneDrive/org/assets/attach/"
           :base-extension "html\\|xml\\|css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|zip\\|gz\\|csv\\|m\\|R\\|el"
           :recursive t
           :publishing-directory "~/workspace/github.io/assets/attach/"
           :publishing-function org-publish-attachment)

          ("css"
           :base-directory "~/OneDrive/org/assets/css/"
           :base-extension "css"
           :recursive t
           :publishing-directory "~/workspace/github.io/assets/css/"
           :publishing-function org-publish-attachment)

          ("js"
           :base-directory "~/OneDrive/org/assets/js/"
           :base-extension "js"
           :recursive t
           :publishing-directory "~/workspace/github.io/assets/js/"
           :publishing-function org-publish-attachment)

          ("rss"
           :base-directory "~/OneDrive/org/blog/"
           :base-extension "org"
           :publishing-directory "~/workspace/github.io/blog"
           :recursive t
           :publishing-function (org-rss-publish-to-rss)
           :html-link-home "http://github.io/linuxing3/"
           :html-link-use-abs-url t)

          ;; 关于github网页的配置
          ;; 将`journal'发布到`awesome-hugo-blog'
          ("hugo-blog"
           :base-directory "~/OneDrive/org/journal/"
           :base-extension "org\\|md\\|\\MD\\|markdown"
           :recursive t
           :publishing-directory "~/workspace/awesome-hugo-blog/content/journal/"
           :publishing-function org-publish-attachment)

          ;; 将`images'发布到`网站根目录'
          ("hugo-images"
           :base-directory "~/OneDrive/org/assets/images/"
           :base-extension "jpg\\|jpeg\\|gif\\|png\\|mp4\\|mov\\|pdf\\|zip\\|gz\\|doc\\|docx\\|csv"
           :recursive t
           :publishing-directory "~/workspace/awesome-hugo-blog/static/images/"
           :publishing-function org-publish-attachment)

          ;; 将`assets'发布到`网站根目录'
          ("hugo-assets"
           :base-directory "~/OneDrive/org/assets/css/"
           :base-extension "css\\|mp4\\|mov\\|pdf\\|zip\\|gz\\|doc\\|docx\\|csv"
           :recursive t
           :publishing-directory "~/workspace/awesome-hugo-blog/assets/css/"
           :publishing-function org-publish-attachment)

          ("[Blog] Org native" :components ("images" "css" "js" "css" "attach" "rss" "blog"))
          ("[Emacs] Fast evil emacs config" :components ("emacs-config"))
          ("[Blog] Github Page Hugo" :components ("hugo-blog" "hugo-images" "hugo-assets"))
          ))

  ) ;; org-public config ends here

;;
;;; NOTE: `构建自己的知识网络'

(use-package emacsql-sqlite3)
;;
;;; `windows'下只能使用`v1'版本
(use-package org-roam
  :ensure nil
  :load-path "~/workspace/org-roam"
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory (dropbox-path "org/roam"))
  :config
  ;; 实现网页抓取的协议
  (require 'org-roam-protocol)
  (setq org-roam-filename-noconfirm nil)

  (if IS-WINDOWS
      (progn
        (setq org-roam-graphviz-executable "B:/app/graphviz/bin/dot.exe")
        (setq org-roam-graph-viewer "C:/Program Files/Microsoft/Edge Beta/Application/msedge.exe")))
  (if IS-LINUX
      (progn
        (setq org-roama-graphviz-executble "dot")
        (setq org-roam-graph-viewer "chromium")))
  ;; 自定义私人笔记标题的处理方法
  (defun linuxing3/org-roam-title-private (title)
    (let ((timestamp (format-time-string "%Y-%m-%d" (current-time)))
          (slug (org-roam--title-to-slug title)))
      (format "%s-%s" timestamp slug)))
  ;; `file' 日记模板 - diaries/20211110.org
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry #'org-roam-capture--get-point "* %?"
           :file-name "daily/%<%Y-%m-%d>"
           :head "#+title: \n#+date: %<%Y-%m-%d-%Z>\n"
           :unnarrowed t)
          ("x" "private" entry #'org-roam-capture--get-point "* %?"
           :file-name "daily/%<%Y-%m-%d>"
           :head "#+title: \n#+date: %<%Y-%m-%d-%Z>\n"
           :unnarrowed t)))
  ;; `file' 自定义笔记模板 - 2021-11-10-title.org
  (setq org-roam-capture-templates
        '(("d" "default" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)"
           :head "#+title: ${title}\n#+date: ${time} \n#+roam_alias: \n#+roam_tags: \n"
           :unnarrowed t)
          ))
  ;; `file' 专业术语模板
  (add-to-list 'org-roam-capture-templates
               '("t" "Term" plain (function org-roam-capture--get-point)
                 "- 领域: %^{术语所属领域}\n- 释义:"
                 :file-name "%<%Y%m%d%H%M%S>-${slug}"
                 :head "#+title: ${title}\n#+roam_alias:\n#+roam_tags: \n\n"
                 :unnarrowed t
                 ))
  ;; `file' 工作试验模板
  (add-to-list 'org-roam-capture-templates
               '("p" "Paper Note" plain (function org-roam-capture--get-point)
                 "* 相关工作\n\n%?\n* 观点\n\n* 模型和方法\n\n* 实验\n\n* 结论\n"
                 :file-name "%<%Y%m%d%H%M%S>-${slug}"
                 :head "#+title: ${title}\n#+roam_alias:\n#+roam_tags: \n\n"
                 :unnarrowed t
                 ))
  ;; `immediate' 即可输入标题和日期，生成一个笔记
  (setq org-roam-capture-immediate-template
        '("d" "default" plain (function org-roam-capture--get-point)
          "%?"
          :file-name "%<%Y%m%d%H%M%S>-${slug}"
          :head "#+title: ${title}\n#+date: ${date}"
          :unnarrowed t))
  ;; `ref' 抓取网页书签到一个用网页标题命名的文件中
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           ""
           :file-name "${slug}"
           :head "\n#+title: ${title}\n#+roam_key: ${ref}\n"
           :unnarrowed t)))
  ;; `content'  抓取一个网页中的内容，多次分别插入到用网页标题命名的文件中
  (add-to-list 'org-roam-capture-ref-templates
               '("a" "Annotation" plain (function org-roam-capture--get-point)
                 "** %U \n${body}\n"
                 :file-name "${slug}"
                 :head "\n#+title: ${title}\n#+roam_key: ${ref}\n#+roam_alias:\n"
                 :immediate-finish t
                 :unnarrowed t))
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))

;; TODO: 使用server进行roam网页互动
(use-package org-roam-server
  :load-path "~/workspace/org-roam-server"
  :ensure nil
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 10000
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20)) ;; org roam config ends here

(provide 'org+fancy-app)
