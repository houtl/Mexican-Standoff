;*******************************************************************************;
;                                                                               ;
;                                                          :::      ::::::::    ;
;    dotemacs                                            :+:      :+:    :+:    ;
;                                                      +:+ +:+         +:+      ;
;    by: thor <thor@42.fr>                           +#+  +:+       +#+         ;
;                                                  +#+#+#+#+#+   +#+            ;
;    Created: 2013/06/18 14:01:14 by thor               #+#    #+#              ;
;    Updated: 2017/11/25 17:55:51 by thou             ###   ########.fr        ;
;                                                                               ;
;*******************************************************************************;

; Load general features files
(setq config_files "/usr/share/emacs/site-lisp/")
(setq load-path (append (list nil config_files) load-path))

(load "list.el")
(load "string.el")
(load "comments.el")
(load "header.el")

(autoload 'php-mode "php-mode" "Major mode for editing PHP code" t)
(add-to-list 'auto-mode-alist '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))

; indent C
(setq c-default-style "bsd")
(setq c-basic-offset 4)
(setq c-tab-always-indent t)
(setq default-tab-width 4)

; autopair
; 自动插入匹配的括号
(defun my-c-mode-auto-pair ()
  (interactive)
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
							   (?{ \n > _ \n ?} >)))
  (setq skeleton-pair t)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "<") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "'") 'skeleton-pair-insert-maybe)
  (backward-char))
(add-hook 'c-mode-hook 'my-c-mode-auto-pair)
(add-hook 'c++-mode-hook 'my-c-mode-auto-pair)

; afficher numero colonne
; 显示列号
(setq column-number-mode t)
(setq toggle-highlight-column-when-idle t)

; highlight double espace et whitespace en fin
; 显示多余空格
(add-hook 'c-mode-common-hook (lambda ()
							   (highlight-regexp "\s\s")))
(add-hook 'c-mode-common-hook (lambda ()
							   (highlight-regexp "\s\n")))
(add-hook 'c-mode-common-hook (lambda ()
							   (highlight-regexp "\t\n")))
(add-hook 'c-mode-common-hook (lambda ()
							   (highlight-regexp "\r\n")))

; backup file
; 备份文件位置
;copie du fichier ~ dans ~/.emacs.d/
(setq backup-directory-alist
 	'(("." . "~/.emacs.d/tmp")))

; Set default emacs configuration
(set-language-environment "UTF-8")
(setq-default font-lock-global-modes nil)
(setq-default line-number-mode t)
(setq-default tab-width 4)
(setq-default indent-tabs-mode t)
(global-set-key (kbd "DEL") 'backward-delete-char)
(setq-default c-backspace-function 'backward-delete-char)
(setq-default c-basic-offset 4)
(setq-default c-default-style "linux")
(setq-default tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
							  64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))

; Load user configuration
(if (file-exists-p "~/.myemacs") (load-file "~/.myemacs"))



;*******************************************************************************;

(defun complete (s)
	(concat s (make-string (- 50 (length s)) ? ))
)

(defun write_header ()
	(interactive)
	(insert "/* ************************************************************************** */\n")
	(insert "/*                                                                            */\n")
	(insert "/*                                                        :::      ::::::::   */\n")
	(insert (complete (concat "/*   " (file-name-nondirectory buffer-file-name))) "      :+:      :+:    :+:   */\n")
	(insert "/*                                                    +:+ +:+         +:+     */\n")
	(insert (complete (concat "/*   By: " (getenv "USER") " <" (getenv "MAIL") ">")) "  +#+  +:+       +#+        */\n")
	(insert "/*                                                +#+#+#+#+#+   +#+           */\n")
	(insert (complete (concat "/*   Created: " (format-time-string "%Y/%m/%d %H:%M:%S") " by " (getenv "USER"))) "     #+#    #+#             */\n")
	(insert (complete (concat "/*   Updated: " (format-time-string "%Y/%m/%d %H:%M:%S") " by " (getenv "USER"))) "    ###   ########.fr       */\n")
	(insert "/*                                                                            */\n")
	(insert "/* ************************************************************************** */\n")
)

(defun header_is_valid ()
	(interactive)
	(push-mark)
	(goto-char (point-min))
	(setq lines (split-string (buffer-string) "\n"))
	(and
		(eq 80 (length (nth 0 lines)))
		(eq 80 (length (nth 1 lines)))
		(eq 80 (length (nth 2 lines)))
		(eq 80 (length (nth 3 lines)))
		(eq 80 (length (nth 4 lines)))
		(eq 80 (length (nth 5 lines)))
		(eq 80 (length (nth 6 lines)))
		(eq 80 (length (nth 7 lines)))
		(eq 80 (length (nth 8 lines)))
		(eq 80 (length (nth 9 lines)))
		(eq 80 (length (nth 10 lines)))
		(string= (nth 0 lines) "/* ************************************************************************** */")
		(string= (nth 1 lines) "/*                                                                            */")
		(string= (nth 2 lines) "/*                                                        :::      ::::::::   */")
		(string-match (regexp-quote "/\*   ") (nth 3 lines))
		(string-match (regexp-quote ":+:      :+:    :+:   \*/") (nth 3 lines))
		(string= (nth 4 lines) "/*                                                    +:+ +:+         +:+     */")
		;(string-match (regexp-quote "/\*   By : ") (nth 5 lines))
		(string-match (regexp-quote "+#+  +:+       +#+        \*/") (nth 5 lines))
		(string= (nth 6 lines) "/*                                                +#+#+#+#+#+   +#+           */")
		;(string-match (regexp-quote "/\*   Created: ") (nth 7 lines))
		(string-match (regexp-quote "#+#    #+#             \*/") (nth 7 lines))
		;(string-match (regexp-quote "/\*   Updated: ") (nth 8 lines))
		(string-match (regexp-quote "###   ########.fr       \*/") (nth 8 lines))
		(string= (nth 9 lines) "/*                                                                            */")
		(string= (nth 10 lines) "/* ************************************************************************** */")
	)
)

(defun header ()
	(interactive)
	(push-mark)
	(goto-char (point-min))
	(if (not (eq t (header_is_valid)))
		(write_header)
	)
)

(defun update_header ()
	(interactive)
	(if (not (eq t (header_is_valid)))
		(goto-char (point-min))
		(setq lines2 (split-string (buffer-string) "\n"))
		(kill-line 11)
		(insert (nth 0 lines2) "\n")
		(insert (nth 1 lines2) "\n")
		(insert (nth 2 lines2) "\n")
		(insert (nth 3 lines2) "\n")
		(insert (nth 4 lines2) "\n")
		(insert (nth 5 lines2) "\n")
		(insert (nth 6 lines2) "\n")
		(insert (nth 7 lines2) "\n")
	(insert (complete (concat "/*   Updated: " (format-time-string "%Y/%m/%d %H:%M:%S") " by " (getenv "USER"))) "    ###   ########.fr       */\n")
		(insert (nth 9 lines2) "\n")
		(insert (nth 10 lines2) "\n")
	)
)

(global-set-key (kbd "C-x s") 'update_header)
(global-set-key (kbd "C-c h") 'header)
