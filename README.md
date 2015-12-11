[Circle Timer](http://www.abefehr.com/circletimer/)
===================================================

An SVG-based jQuery and Zepto circular timer plugin.

How to use
----------
Fork this repository or download the `circletimer.min.js` and `circle.css` files from the `dist` directory of this project.

### Options

* **timeout** *(number)*:  the time that the timer should count for, in milleseconds. The default value is `5000`
* **onComplete** *(function)* the callback to be executed when the time has run out. The default value is an empty function
* **onUpdate** *(function)* the callback to be executed each update of the timer. The default value is an empty function
* **clockwise** *(boolean)* whether or not the timer should be going clockwise. If set to false, the timer moves counterclockwise. The default value is `true`


### Example Code

```JavaScript
$("#example-timer").circletimer({
  onComplete: function() {
    alert("Time is up!");
  },
  onUpdate: function(elapsed) {
    $("#time-elapsed").html(Math.round(elapsed));
  },
  timeout: 5000
});

$("#start").on("click", function() {
  $("#example-timer").circletimer("start");
});

$("#pause").on("click", function() {
  $("#example-timer").circletimer("pause");
});

$("#stop").on("click", function() {
  $("#example-timer").circletimer("stop");
});

$("#add").on("click", function() {
  $("#example-timer").circletimer("add", 1000);
});
```

Contributing
------------
This plugin is written in [CoffeeScript](http://coffeescript.org) and is compiled to JS using a [Grunt task](http://gruntjs.com). Commenting of functions in the CoffeeScript is done using the [Codo](https://github.com/coffeedoc/codo) syntax.

### Steps to contribute:

1. Fork the repository
2. Install the Codo NPM module globally using `npm install -g codo`
3. Install the rest of the NPM modules required by executing `npm install` from the root of the repo
4. Make your desired changes in `src/circletimer.coffee` and `src/circletimer.scss`
5. Compile your changes to JS by executing `grunt` from the root of the repo
6. Check out if they work by serving the `index.html` file in the root of the directory using your new change
7. If it works, create a pull request with the new change!
8. Pat yourself on the back and reward yourself with a candy bar! Mmmmm, candy.

License
-------

This code is released under the [MIT License](LICENSE)