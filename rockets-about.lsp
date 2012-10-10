#!/usr/bin/env newlisp

(load "/var/www/newlisp-rockets.lisp") ; this is where the magic happens!

; (rockets-verify.lsp) - Rockets - User verification page 
; 
; This is the first version of the self-hosted blog for newLISP on Rockets.
; The blog is designed to showcase how you would use Rockets for a real application.
; 
; Written 2012 by Rocket Man

(display-header)
(open-database "ROCKETS-BLOG")
(display-partial "rockets-checksignin") ; checks to see if user is signed in
(display-navbar "newLISP on Rockets" '(("Home" "rockets-main") ("About" "rockets-about" "active") ("Contact" "rockets-contact") ("Register" "rockets-register")) "rockets-verify")

(start-div "hero-unit")
	(displayln "<h2>The newLISP on Rockets Blog</h2>")
	(displayln "<P>Currently running newLISP on Rockets version: " $ROCKETS_VERSION "</p>")
	(displayln "<h3>What is newLISP on Rockets?</h3>")
	(displayln "<P><a href='http://newlisp.org'>newLISP</a> is a fast and flexible scripting language that uses a LISP syntax.")
	(displayln "It's very easy to learn and use.</p>")
	(displayln "<p>Rockets is a framework written in newLISP that is designed for rapid prototyping of web-based applications.")
	(displayln "It uses <a href='http://twitter.github.com/bootstrap/'>Bootstrap</a> for its user interface as well as <a href='http://jquery.com/'>jQuery</a>.")
	(displayln "<p>The framework is open-source, licensed under the <a href='http://www.gnu.org/licenses/old-licenses/gpl-2.0.html'>GPL</a>.")
	(displayln "The source code for both the framework and this blog are available at: <a href='https://github.com/newlisponrockets/newLISP-on-Rockets'>https://github.com/newlisponrockets/newLISP-on-Rockets</a>.</p>")
	(displayln "<h3>How about a Hello World?</h3>")
	(displayln "<p>Sure!  Here's one:</p>")
	(displayln "<br>#!/usr/bin/env newlisp")
	(displayln "<br>(load \"/var/www/newlisp-rockets.lisp\")")
	(displayln "<br>(display-header)")
	(displayln "<br>(display-navbar \"Hello World\")")
	(displayln "<br>(start-div \"hero-unit\")")
	(displayln "<br>(displayln \"Hello, World!\")")
	(displayln "<br>(end-div)")
	(displayln "<br>(display-footer)")
	(displayln "<br>(display-page)")
	(displayln "<h3>Is that it?</h3>")
	(displayln "<p>newLISP on Rockets is currently in the early stages of development.  You are welcome to peruse the <a href='rockets-main.lsp'>blog</a> for updates on the project.")
(end-div)

;(displayln "<p>Debug stuff here...</p>")

(close-database)
(display-footer "Rocket Man")
(display-page) ; this is needed to actually display the page!