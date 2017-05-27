#May be helpful
#Tanks to https://bbs.archlinux.org/viewtopic.php?id=131526
#!/bin/bash
#case "$1" in
#  get)
##Uncomment below if you want to.
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u | grep '.\(jpe\|jp\|pn\)g$'
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u | grep '.\(htm\|html\|\)g$'
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u | grep '\(youtube\|html\|\)g$'
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u 
##curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e title -u 
#curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e url -u 	 
#        exit  
#        ;;
#  title)
#curl -s http://www.reddit.com/r/$2.json | jshon -e data -e children -a -e data -e title  -u      
#;;

#  help)
#echo "run ./reddit get subredditname"
#echo "run ./reddit title subdredditname "
#;;

# user)
#curl -s http://www.reddit.com/user/$2.json | jshon -e data -e children -a -e data -e body -u         
#;;

# login)
#echo "Reddit Username?"
#read user
#echo "Reddit Password?"
#read passwd
#curl -s -d "api_type=json&passwd=$passwd&user=$user" http://www.reddit.com/api/login/$user >> cookie.json
##curl -s https://ssl.reddit.com/prefs/friends.json | jshon -e data -e children -a -e data -e name -u  
#;;
#esac
