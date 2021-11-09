﻿;;; init.el --- A Fancy and Fast Emacs Configuration.	-*- lexical-binding: t no-byte-compile: t -*-

;; Copyright (C) 2006-2021 linuxing3

;; Author: Xing Wenju <xingwenju@gmail.com>
;; URL: https://github.com/linuxing3/evil-emacs-config
;; Version: 5.9.0
;; Keywords: .emacs.d

;;
;;   Evil EMACS - Enjoy Programming & Writing
;;

;;; Commentary:
;;
;; Centaur Emacs - A Fancy and Fast Emacs Configuration.
;;

;;; Code:



;; ;; ---------------------------------------------------------
;; ;; 自动加载帮助器
;; ;; ---------------------------------------------------------
(require 'module-helper)
(require 'module-lib)

;; ;; ---------------------------------------------------------
;; ;; 包管理器
;; ;; ---------------------------------------------------------
(require 'module-packages)

;; ;; ---------------------------------------------------------
;; ;; 功能模块
;; ;; ---------------------------------------------------------

(require 'module-base)
(require 'module-ui)
(require 'module-evil)

;; ;; ---------------------------------------------------------
;; ;; Org功能模块
;; ;; ---------------------------------------------------------

(require 'module-org)

;; ;; ---------------------------------------------------------
;; ;; 编程模块
;; ;; ---------------------------------------------------------
(require 'module-project)
(require 'module-completion)
(require 'module-snippets)
(require 'module-format)
(require 'module-coding)
(require 'module-service)

;; ;; ---------------------------------------------------------
;; ;; App模块
;; ;; ---------------------------------------------------------
(require 'module-app)
;; ;; ---------------------------------------------------------
;; ;; 快捷键绑定
;; ;; ---------------------------------------------------------
(require 'module-keybinds)
