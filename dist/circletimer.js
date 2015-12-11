var $, methods;

$ = window.jQuery || window.Zepto;

window.requestAnimFrame = (function() {
  return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || function(callback) {
    return window.setTimeout(callback, 1000 / 60);
  };
})();

methods = {
  init: function(options) {
    var circle, data, defaults, div, svg;
    this.empty();
    defaults = {
      timeout: 5000,
      onComplete: (function() {}),
      onUpdate: (function() {}),
      clockwise: true
    };
    data = {};
    data.options = $.extend(defaults, options);
    this.data("ct-meta", data);
    circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    circle.setAttributeNS(null, "r", "25%");
    circle.setAttributeNS(null, "cx", "50%");
    circle.setAttributeNS(null, "cy", "50%");
    circle.setAttributeNS(null, "stroke-dasharray", (50 * Math.PI) + "%");
    svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.appendChild(circle);
    div = $("<div></div>");
    div.attr("id", "ct-circle-container");
    div.append(svg);
    return this.append(div);
  },
  start: function() {
    var circle, data, lastTimestamp, step;
    data = this.data("ct-meta");
    if ((data.timeElapsed == null) || data.timeElapsed === data.options.timeout) {
      lastTimestamp = null;
      data.timeElapsed = 0;
    }
    if (data.reqId != null) {
      window.cancelAnimationFrame(data.reqId);
    }
    circle = $(this).find("circle");
    step = function(timestamp) {
      var direction;
      if (lastTimestamp != null) {
        data.timeElapsed += timestamp - lastTimestamp;
      }
      lastTimestamp = timestamp;
      direction = data.options.clockwise ? -1 : 1;
      circle.css("stroke-dashoffset", (direction * 50 * Math.PI * data.timeElapsed / data.options.timeout) + "%");
      if (data.timeElapsed < data.options.timeout) {
        data.reqId = window.requestAnimationFrame(step);
        return data.options.onUpdate(data.timeElapsed);
      } else {
        data.timeElapsed = data.options.timeout;
        data.options.onUpdate(data.timeElapsed);
        return data.options.onComplete();
      }
    };
    data.reqId = window.requestAnimationFrame(step);
    return this.data("ct-meta", data);
  },
  stop: function() {
    var data;
    data = this.data("ct-meta");
    window.cancelAnimationFrame(data.reqId);
    data.timeElapsed = 0;
    data.options.onUpdate(data.timeElapsed);
    return this.data("ct-meta", data);
  },
  pause: function() {
    var data;
    data = this.data("ct-meta");
    window.cancelAnimationFrame(data.reqId);
    return this.data("ct-meta", data);
  },
  add: function(addend) {
    var data;
    data = this.data("ct-meta");
    if (addend < data.timeElapsed) {
      data.timeElapsed -= addend;
    } else {
      data.timeElapsed = 0;
    }
    return this.data("ct-meta", data);
  }
};

$.fn.circletimer = function(methodOrOptions) {
  if (methods[methodOrOptions]) {
    return methods[methodOrOptions].apply(this, Array.prototype.slice.call(arguments, 1));
  } else if (typeof methodOrOptions === "object" || !methodOrOptions) {
    return methods.init.apply(this, arguments);
  } else {
    return $.error("Method " + methodOrOptions + " does not exist in circletimer!");
  }
};
