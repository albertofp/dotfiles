# Homework 1: Pointers

![anya_pointers](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.kym-cdn.com%2Fphotos%2Fimages%2Foriginal%2F002%2F811%2F050%2F444.jpeg&f=1&nofb=1&ipt=c5a77467e4c0b8fc9c182181e0d19aaaa0d25f350b4df37190415d36f9e1010d&ipo=images)

Suppose you have an object "Menu" that is a list of omni food items. Write a function that takes a pointer to that object and replaces all of them with vegan alternatives.

The example below is in Go, but you can solve this in any language.

```go
package main

// original menu
var menu = []string{"Eggs", "Cheese", "Ham", "Bacon", "Sausage"}

// vegan menu
var veganMenu = []string{"Tofu", "Seitan", "Vurst", "Tempeh", "Tunah"}
```

Note that we want to replace the original menu with the vegan menu, not simply create a new menu.

**Deadline: Sunday 19.01.2025 11:59 PM**
