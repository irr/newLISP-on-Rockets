; rockets-common-functions.lsp
;
; partial file with global variables and functions that are common to the blog but not to Rockets itself
;

; GLOBAL VARIABLES - under the context "Blog" to distinguish from framework context "Rockets"
(set 'Blog:posts-per-page 10) ; number of posts per page
(set 'Blog:forum-posts-per-page 20) ; number of posts per page on the forums
(set 'Blog:rocket-cookie-name "rockets-4dckq3-e4jcx-2wgxc")

; this function displays an individual post with headers and the post itself
; also shows comments if bool-show-comments is true, and allows a logged-in user to reply
; also allows post to be shown in forum view if forum-view-post=true
(define (display-individual-post list-post-data bool-show-comments str-linkback-id)
	(if forum-view-post (begin ; ---- begin forum view of post + comments
		(displayln "<h3>" (list-post-data 3) "</h3>")
		(set 'header-list '("Author" "Message"))
		(set 'post-data (list (string "<img src='images/avatars/" (author-avatar (list-post-data 1)) "' width=64 height=64><br>" (author-name (list-post-data 1)) "<h6>Posts: " (author-posts (list-post-data 1)) "</h6>") (format-for-web (list-post-data 4))))
		(set 'PostId (int (list-post-data 0)))
		(set 'post-data (list post-data)) ; okay these two lines of code are duplicated... I can live with it for now
		(set 'post-comments (get-record "Comments" PostId))
		(if post-comments (begin
			(dolist (p post-comments)
				(push (list (string "<img src='images/avatars/" (author-avatar (p 2)) "' width=64 height=64><br>"(author-name (p 2)) "<h6>Posts: " (author-posts (p 2)) "</h6>") (format-for-web (p 5))) post-data -1)) ; add each comment to the thread
		))
		(display-table header-list post-data "striped") 
	)
	(begin ;  ------ begin blog view of post + comments
		(displayln "<h4><a href='rockets-item.lsp?p=" (list-post-data 0) "'>" (list-post-data 3) "</a></h4>")
		(displayln "<br><b>Post #:</b> " (list-post-data 0) )
		(displayln "<BR><B>Date:</b> " (list-post-data 2) "")
		(displayln "<br><B>Author:</b> " (author-name (list-post-data 1)) "")
		(displayln "<br><br><p>" (format-for-web (list-post-data 4)) "</p>")
		(if (= Rockets:UserId 0) (displayln "<br><a class='btn btn-danger' href='rockets-delete.lsp?post=" (list-post-data 0) "'>Delete post</a>"))
		(if (= Rockets:UserId 0) (displayln "<a class='btn btn-info' href='rockets-item.lsp?p=" (list-post-data 0) "&edit=yes#edit'>Edit post</a>"))
		; print reply button if we're not on main page and if valid account is logged in
		(if (and Rockets:UserId (not bool-show-comments)) (begin
			(displayln "<a class='btn btn-primary' href='rockets-item.lsp?p=" (list-post-data 0) "&r=1#reply'>Reply to post</a>")))
		(if (and (list-post-data 5) (not bool-show-comments)) (begin				; show number of comments if any, and show actual comments in a list if requested
			(displayln "<a class='btn btn-success' href='rockets-item.lsp?p=" (list-post-data 0) "#reply'>Comments (" (list-post-data 5) ")</a>")))
		(if bool-show-comments (begin
			(displayln "<br>")
			(if (list-post-data 5) (begin 			; display all comments here if they exist
				(set 'PostId (int (list-post-data 0)))
				(set 'post-comments (get-record "Comments" PostId))
				(dolist (p post-comments)
					(start-div "media")
					(displayln "  <a class=\"pull-left\" href=\"#\">")
					(displayln "    <img class=\"media-object\" src=\"images/avatars/" (author-avatar (p 2)) "\" width=64 height=64>")
					(displayln "  </a>")
					(start-div "media-body")
					(displayln "<h4 class=\"media-heading\">" (author-name (p 2)) " on " (p 3) "</h4>")
					(displayln "<i>" (format-for-web (p 5)) "</i>")
					(end-div) 
					(end-div)
					(displayln "<hr>")
					)
			))		
		))
		(displayln "<hr>")
		(if bool-show-comments (displayln "<a class='btn btn-primary' href='rockets-item.lsp?p=" (list-post-data 0) "&f=true'>View this post in the forums</a>"))
	))
			; the following parts are common to both forum and blog view
			(if bool-show-comments (begin				; but don't show it on the main page
				(if Rockets:UserId (begin					; show the comment reply box if a user is logged in
					(displayln "<a name='reply'></a>") 	; display an html anchor so we can jump to it
					(display-post-box "Post a reply..." "postsomething" "rockets-comment-post.lsp" nil "replybox" "Post Message" str-linkback-id nil nil forum-view-post)
					; we need to pass in "forum-view-post" as a hidden variable so that we can return to the forum view when we return after replying
				))
			))
)

; Get the user's name given the user Id
(define (author-name str-author-id)
	(set 'str-author-id (int str-author-id))
	(set 'get-user-name-query (query (string "SELECT UserName FROM Users WHERE UserId=" str-author-id ";")))
	(if (nil? get-user-name-query)
		(set 'result-name "Unknown User"))
	(if (= str-author-id 0)
		(set 'result-name (string "<span class='text-error'>" (first (first get-user-name-query)) "</span>")) ; red names for admin.  It's funny that admin gets error styled text!
		(set 'result-name (string "<span class='text-info'>" (first (first get-user-name-query)) "</span>")) ; blue names for everyone else (at the moment)
	)
)

; Get the user's postcount given the user Id
(define (author-posts str-author-id)
	(set 'str-author-id (int str-author-id))
	(set 'get-user-posts-query (query (string "SELECT UserPosts FROM Users WHERE UserId=" str-author-id ";")))
	(if (nil? get-user-posts-query)
		(set 'result-name "0"))
	(set 'result-name (first (first get-user-posts-query)))	
)

; Get the user's avatar given the user Id
(define (author-avatar str-author-id)
	(set 'str-author-id (int str-author-id))
	(set 'get-user-avatar-query (query (string "SELECT UserAvatar FROM Users WHERE UserId=" str-author-id ";")))
	(if (or (nil? get-user-avatar-query) (= (first (first get-user-avatar-query "nil"))))
		(set 'result-string "unknown.png")
		(set 'result-string (first (first get-user-avatar-query))))
)
