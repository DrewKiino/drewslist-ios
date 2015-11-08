
#Drew's List iOS#

###Design Philosophy###

**curated list:** https://github.com/matteocrippa/awesome-swift

**curated list 2** https://github.com/Wolg/awesome-swift

**'Is there a framework for this?', 'Should I reinvent the wheel?'**

As a developer, we must ask ourselves this question. A prime example is Toucan's image library, which handles core image processing and masking features. We could create our own classes and services that handles these dilemmas, yet all of that can be done in two lines of code using this framework :) gradually speeding up the development process without having to write native code for it. Another example is using Realm.io which handles persistent data for iOS apps. As you know, Core Data, apple's native persistent data solution sucks butt and is a headache to implement. Realm solves this easily. The downside of this is having to conform the configuration that the framework which could severely handicap a team's ability to create new features since it is bound to that framework's capabilities. I came across the argument of **Convention vs Configuration**, to me it means do I have to create a feature from the ground-up, which lets me able to have complete control over what this feature can do, or do I have to create a feature that will allow me to do something but doesn't have much impact in the app? For image processing, definitely use frameworks. But for things like upload forms and isbn scanners, our app is pretty dependent on maximizing these features, so even though there are ISBN scanner frameworks online, it's best that we build these things from the ground up. When we develop, we have to ask ourselves these questions, and being able to answer these questions effectively allos us to develop features in time :) 

**frameworks = not having to reinvent the wheel**

####Our solutions for developer implmentations:

1. Persistent iOS Data Storage - [Realm.io](https://realm.io/)
2. Http Services - [Alamofire](https://github.com/Alamofire/Alamofire)
3. JSON Handling
  * Parsing - [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
  * Object Mapping - [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)
