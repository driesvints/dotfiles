# superlumic-config

This is the default configuration "role" for "superlumic". You will want to fork this one and create your own "username.yml". Use the roles folder to create "profiles".

How you organise your config files is entirely up to you, but this is how I do it. The "profile-all" role are the apps and settings that everyone in my company needs. Then I have a group file per type of installation (developers, designers, etc). In the "username.yml" playbook I then add all the specific things for that user.
