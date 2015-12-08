# label_maker
Project to make a PDF file for Avery labels from a source file. 

Currently this Perl script uses a programmatic list of tab delimted
items to create labels. It used to be a cgi script that created a 
text file. Then you would click on the text file to download it.

I would like to turn this into a web project that could easily be
hosted somewhere and just takes an upload from a form and then
prompts for a download. I'm thinking something like an
Openshift project that could be hosted for free using 1 gear or
something like that.

Seems like a good thing to work with a Bootstrap config that just
accepts an upload and delivers a PDF file.
