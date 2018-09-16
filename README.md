# Wordpress-Synchronization
Script for synchronizing a Worpress server between a localhost and a server hosted over the Internet.

# Problem
It's very painfull to create or update a Wordpress website when you have a low internet bandwith. It takes a while to load images, videos and to edit the pages of a blog. And this is not possible at all when you have no connection...

# Solution
Install Wordpress localy on your computer, and then load, edit and administrate your local wordpress. Because it's local (http://localhost/wordpress/), it's fast and it never stalls due to a poor bandwith! When you are happy with your local wordpress, shoot a script that synchronizes your work with a wordpress server hosted over the Internet. When the script is over, your wordpress website is accessible to your public.

My first idea was to call this script by executing a Wordpress plugin on my localhost. I tested several plugins in the Wordpress catalog but they either didn't provide this function, or I had to pay it... Thus I decided to write this simple shell script. I run it on my Macbook. I didn't test it on Unix/Linux platform, but it should work also.

# Pre-requisites
1) Install Worpress on your local machine. That means the installation and configuration of Apache, PHP, MySQL and Wordpress application.
2) Install Wordpress on an internet server (like AWS). An SSH access to this server is required.
3) Ideally, the MySQL version should be the same on both servers. In my case, I had to manage 2 different versions: MySQL 8.0 on localhost and MySQL 5.5 on the internet server.

# Use case
I used this script to edit a blog during a roadtrip. I was in areas that had very poor and sometimes no internet connexion. With this solution, I could edit my blog in a daily basis, on my local machine. And times to times, I was running this script during the night to update my blog over the internet.

# Improvements
This script might be improved with :
1) Option to automatically re-run the files synchronization when it fails in the middle.
2) Passwords management.
