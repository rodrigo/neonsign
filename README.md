# README

_This is the most useless and fun project I've ever made._
Neon Signs For Git is a rails project that allows you to draws pixel art into github contribution charts.
Check it out on http://neonsignsforgit.com

## Some things TODO
- Enable ssl
- refactor the git_painter service
- Enable options like random paint, degrade background, solid background, etc.
- I'm really trying to figure out how to make it recurrent. My first and actually only idea was to create an orphan branch, delete the main, rename the orphan to main and force push, but this don't erase the contributions. I've read in some forums that is a github bug and that you have to talk with the support to erase contributions after a force push. Very sad. Eventually I'll try to delete the repo and create another using the api but that would require to inform an api key with admin powers, wich is unsafe even for recreative use only (but seems the only way).
