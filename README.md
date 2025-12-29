# Reactive Tags

Reactive Tags is a little module that helps you structure and organize the way your code works.
Similarly to *TailWindCSS* and *React*, you can add custom behaviors to instances by simply giving them a tag and optional parameters. That means you'll be able to create tens of unique interactions without having to write a single line of code.

How it works:
- Install ReactiveTags
- Set the ReactiveSubmodule folder attribute
- Install/Create a [Reactive Submodule](https://github.com/bajsucks/ReactiveSubmodules)
- Add the `Reactive` tag to any of the instances you want to affect
- Add the custom tag imported from the submodule to that instance
- Add the options attributes from the imported submodule, if any
- Run .Init() during runtime
Voula, instances with the tags are now affected by that submodule!

And the best thing? It supports *any* function. That creates an entire new realm of importing functionality. Because of the way Reactive Submodules utilize attributes, you can give any specific instance it's own setting in a matter of seconds and modify it on-the-fly.
A good usage example of Reactive Submodules would be *UI Animations and interactivity.* Instead of connecting every element you want to react to clicks and every element you want to open a certain window, you can create a single reactive submodule with tags *Clicky*, *WindowManager* and *Window*, give them to respective instances and be done with it. And now, when you want to change a specific window to have a different animation, or, for example, close other windows when it's open, you can do it by simply giving the needed windows a new attribute. Isn't that so simple?

## But isn't that just CollectionService?
It is, and that's the beauty of it. ReactiveTags is a wrapper for CollectionService meant to simplify and standartize creation and usage of such functionality. Instead of having each different module having it's own custom implementation of tags, Reactive Submodules use a single handler which is ReactiveTags.

It also provides a repository to easily find, install and contribute to public Reactive Submodules.