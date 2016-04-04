(function(){
  var Conway = function(args) {
    var self = this;
    var scaler = args.scaler;
    var canvas = args.canvas;
    var context = canvas.getContext("2d");

    var population = args.population;
    var generation = args.generation;
    var autoRun = args.autoRun;
    var nextGeneration = args.nextGeneration;

    var width = Math.round(canvas.width * (scaler.value / 100));
    var height = Math.round(canvas.height * (scaler.value / 100));

    var world = new World(width, height, function(x,y) {
      return new Cell(Math.round(Math.random()));
    });

    var view = new View(context, (scaler.value / 100));

    self.tick = function () {
      var scale = (scaler.value / 100);
      var newWidth = Math.round(canvas.width * scale);
      var newHeight = Math.round(canvas.height * scale);
      var oldWorld = world;
      world = oldWorld.newGeneration(newWidth, newHeight);
      render(world, scale);
    };

    self.run = function () {
      setInterval(function () {
        if (autoRun.checked) {
          self.tick();
        }
      }, 100);
    };
    args.nextGeneration.onclick = function() {
      if (!autoRun.checked) {
        self.tick();
      }
    };

    var renderDetails = function(world) {
      population.innerHTML = world.population;
      generation.innerHTML = parseInt(generation.innerHTML) + 1;
    };

    var render = function(world, scale) {
      view.setScale(scale);
      world.cells.forEach(function(row, y, _a) {
        row.forEach(function(cell, x, _a) {
          if (cell.state === 0) {
            view.setPixel(x, y, { r: 255, g: 255, b: 255 });
          } else {
            view.setPixel(x, y, { r: 0, g: 0, b: 0 });
          }
        });
      });

      view.render();
      renderDetails(world);
    };
  };

  var World = function(x,y,callback) {
    var self = this;
    this.width = x;
    this.height = y;
    this.population = 0;

    this.buildWorld = function(callback) {
      var cells = new Array(self.height);
      for(var y = 0; y < cells.length; y++) {
        var row = new Array(self.width);
        for(var x = 0; x < row.length; x++) {
          var cell;
          if (callback) {
            cell = callback(x,y);
          } else {
            cell = new Cell(0);
          }
          row[x] = cell;
          if (cell.state !== 0) {
            self.population += 1;
          }
        };
        cells[y] = row;
      };
      return cells;
    };

    this.cells = self.buildWorld(callback);

    this.newGeneration = function(width, height) {
      return new World(width, height, function(x,y) {
        return self.cellAt(x, y).evolve(self.neighbourhood(x,y));
      });
    };

    this.cellAt = function(x,y) {
      return (self.cells[y] || [])[x] || new Cell(0);
    }

    this.neighbourhood = function(x,y) {
      var around = new Array(8);

      around[0] = self.cellAt(x-1, y-1);
      around[1] = self.cellAt(x, y-1);
      around[2] = self.cellAt(x+1, y-1);
      around[3] = self.cellAt(x-1, y);
      around[4] = self.cellAt(x+1, y);
      around[5] = self.cellAt(x-1, y+1);
      around[6] = self.cellAt(x, y+1);
      around[7] = self.cellAt(x+1, y+1);

      return around;
    };
  }

  var Cell = function(state) {
    var self = this;
    this.state = state;
    this.evolve = function(neighbourhood) {
      var neighbours = 0;
      neighbourhood.forEach(function(cell, _i, _a) {
        if (cell.state === 1) {
          neighbours += 1;
        }
      });
      if (self.state === 0) {
        if (neighbours === 3) {
          return new Cell(1);
        } else {
          return new Cell(0);
        }
      } else {
        if ((neighbours === 2) || (neighbours === 3)) {
          return new Cell(1);
        } else {
          return new Cell(0);
        }
      }
    }
  };

  var View = function(context, scale) {
    var self = this;
    this.context = context;

    this.setScale = function(newScale) {
      self.scale = newScale;
      self.width = Math.round(context.canvas.width * self.scale);
      self.height = Math.round(context.canvas.height * self.scale);
    }
    self.setScale(scale);
    var data = new Array(self.width * self.height * 4);

    this.setPixel = function(x, y, color) {
      if (x < 0 || x >= self.width || y < 0 || y > self.height) {
        throw new Error("Out of bounds (" + x + ", " + y + ")");
      }

      data[(y * self.width + x) * 4 + 0] = color.r;
      data[(y * self.width + x) * 4 + 1] = color.g;
      data[(y * self.width + x) * 4 + 2] = color.b;
      data[(y * self.width + x) * 4 + 3] = 255;
    };

    this.render = function() {
      var imageData = self.context.createImageData(self.width, self.height);

      var howMuchData = self.width * self.height * 4;
      for (var i = 0; i < howMuchData; i += 1) {
        imageData.data[i] = data[i];
      }

      context.putImageData(imageData, 0, 0);
      context.drawImage(context.canvas, 0, 0, self.width, self.height, 0, 0, self.context.canvas.width, self.context.canvas.height)
    };
  };

  if (typeof window !== "undefined") {
    window.Conway = Conway;
  };
})();
