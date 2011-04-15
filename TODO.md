Features
--------
  - Create a plugin system so that you can just drop plugins into a folder and have them work
  - Create a way for the plugins to interact with the same mongodb

Plugins
-------
  * tell: Have someone issue a 'tell' command and then have vertexbot repeat it back to whom they want.

    Example:

       PersonA: vertexbot, tell PersonB Apples are better than oranges
       vertexbot: As you wish
       ... 5 minutes later
       ** PersonB join the channel
       vertexbot: PersonB, message from PersonA (5 minutes ago): Apples are better than oranges

  * imageme: Google Image search the argument string and return a link to the first image returned
    Example:
      PersonA: vertexbot, imageme hipster cat
      vertexbot: PersonA, http://imgur.com/some-hipstercat-image.jpg
  * deploy: Given a project name, and proper configuration, deploy one of my projects.
            If theres an error, gist the error and give me the link. Otherwise, report success.
    Example:
      PersonA: vertexbot, deploy nodesite.com
      vertexbot: PersonA, nodesite.com deploy sucessfully!
      OR
      vertexbot: PersonA, Error deploying nodesite.com! Error: https://gist.github.com/GISTID
  * sms: Allow authorized people to send me a text message.
    Example:
      PersonA: vertexbot, text PersonB Your mothers a banana.
      vertexbot: PersonA, text message sent!
      OR
      vertexbot: PersonA, You are not authorized to text!
  * weather: Given a zip code, return the 3 day forcast. Perhaps add options.
    Example:
      PersonA: vertexbot, weather 27518
      vertexbot: PersonA, Today: High 71, Low 42. Tomorrow: High 64, Low 43, Chance of Rain
  * math: Given an expression, compute the result
    Example:
      PersonA: vertexbot, math 2+3
      vertexbot: PersonA, 5
  * quote: Given a movie or tv show title, return a quote from it
    Example:
      PersonA: vertexbot, quote The Matrix
      vertexbot: PersonA, I know Kung Fu -- Neo
  * lmgtfy: Given a string, produce a lmgtfy link
    Example:
      PersonA: vertexbot, lmgtfy foobar
      vertexbot: PersonA, http://lmgtfy.com/?q=foobar
  * test: Run tests for a configured project, return the result. If errors, gist the output
    Example:
      PersonA: vertexbot, test foobar
      vertexbot: PersonA, All tests past for foobar!
      OR
      vertexbot: PersonA, Errors running tests for foobar. http://gist.github.com/GISTID

  - lastgist: Post the link to the last gist I  created. Alternatively, allow for searching or filtering by language
