var ThreeDee = function(selector, options) {
  this.selector = selector;
  this.options = options;
  this.init();
};

ThreeDee.prototype = {
  load_indicator: function(progress) {
    var percent = Math.round(progress.loaded / progress.total*50) + '%';
    var bar = $(this.selector + ' .preloader .front');
    var indicator = $(this.selector + ' .preloader .percent');
    bar.css('width', percent);
    indicator.text(percent);
  },

  parse_indicator: function(info, progress) {
// WTF?! doesn't seem to update indicator
    console.log(info, progress);
    var percent = Math.round(50 + progress/2) + '%';
    var bar = $(this.selector + ' .preloader .front');
    var indicator = $(this.selector + ' .preloader .percent');
    var title = $(this.selector + ' .preloader .title');
    bar.css('width', percent);
    indicator.text(percent);
    title.text(info + '...');
  },

  load_handler: function ( collada ) {
    this.dae = collada.scene;

    this.deepComputeBoundingBoxAndSphere(this.dae);

    // Detect clickable objects
    var nodes = this.dae.children
      // Only use those nodes starting with 'node-'
      .filter(function(child) { return child.name.indexOf("node-") === 0; });

    this.intersect_objects = nodes
      // WTF, nesting in nesting in model_00 again
      .map(function(object) {
        if(object.children.length === 1) {
          if(object.children[0].children.length === 1) {
            return object.children[0].children[0];
          } else if(object.children[0].children.length === 0) {
            return object.children[0];
          }
        }
      });

    this.unit_bubbles = {};

    nodes.forEach(function(unit) {
      var unit_id = unit.name.substring(5);
      return this.bubble_handler(null, unit_id);
    }, this);

    this.scene.add(this.dae);

    var camera = this.dae.children.filter(function(node) { return node.name === "Camera001"; })[0];
    // We agreed on PI/6. Model files may containg different angles resulting in camera jump.
    // Recalculate y (height) basing on PI/6
    var y = Math.sqrt( Math.pow(camera.position.x, 2) + Math.pow(camera.position.z, 2) ) * Math.PI/6;
    this.camera.position.setX(camera.position.x);
    this.camera.position.setY(y);
    this.camera.position.setZ(camera.position.z);
    this.camera.lookAt(this.scene.position);

    $(this.selector + ' .preloader').hide();
    $(this.selector + ' canvas').show();

    this.render();
  },

  load_fail_handler: function(url, status) {
    console.log('[3D] [ERROR] load failed: ', url, status);
    $(this.selector + ' .preloader').hide();
    $(this.selector + ' .load-failed').show();
  },

  load: function(url) {
    $(this.selector + ' canvas').hide();
    $(this.selector + ' .load-failed').hide();
    $(this.selector + ' .preloader').show();
    var loader = new THREE.ColladaLoader();
    loader.options.convertUpAxis = true;

    this.scene.remove(this.dae);

    for(var unit_id in this.unit_bubbles) {
      var unit_bubble = this.unit_bubbles[unit_id];
      this.scene.remove(unit_bubble);
    }

    loader.load(url,
      this.load_handler.bind(this),
      this.load_indicator.bind(this),
      this.parse_indicator.bind(this),
      this.load_fail_handler.bind(this));
  },

  deepComputeBoundingBoxAndSphere: function(object) {
    object.children.forEach(this.deepComputeBoundingBoxAndSphere, this);
    if(object.geometry) {
      object.geometry.computeBoundingBox();
      object.geometry.computeBoundingSphere();
    }
  },

  init: function() {
    var root_unit_id = window.app.TreeInterface.getRootUnitId();
    var model_url = window.app.TreeInterface.getModelURLByUnitId(root_unit_id);

    this.intersect_objects = [];

    this.container = $(this.selector)[0];
    var width = this.options.sceneWidth,
        height = this.options.sceneHeight;
    if (!width && !height) {
        width = this.container.clientWidth - this.options.marginWidth;
        height = window.innerHeight - this.options.marginHeight;
    }

    // if ( ! Detector.webgl ) Detector.addGetWebGLMessage();
    if ( Detector.webgl )
      this.renderer = new THREE.WebGLRenderer( {antialias:true} );
    else
      this.renderer = new THREE.CanvasRenderer();

    this.renderer.autoUpdateObjects = false;
    this.renderer.setSize(width, height);

    this.container.appendChild( this.renderer.domElement );

    this.projector = new THREE.Projector();

    var aspect = width / height;
    var d = 100;
    this.camera = new THREE.OrthographicCamera( - d * aspect, d * aspect, d, - d, -1000, 1000 );

    this.scene = new THREE.Scene();

    var render_handler = function() { this.render(); }.bind(this);

    // Controls
    var controls = new THREE.OrbitControls( this.camera, this.renderer.domElement );
    controls.addEventListener( 'end', render_handler );
    controls.addEventListener( 'change', render_handler );

    controls.maxPolarAngle = Math.PI / 3;
    controls.minPolarAngle = Math.PI / 3;
    controls.zoomSpeed = 1;
    controls.dollyIn = function( dollyScale ) {
      if ( dollyScale === undefined ) dollyScale = Math.pow( 0.95, this.zoomSpeed );
      this.object.scale.x *= dollyScale;
      this.object.scale.y *= dollyScale;
    };
    controls.dollyOut = function( dollyScale ) {
      if ( dollyScale === undefined ) dollyScale = Math.pow( 0.95, this.zoomSpeed );
      this.object.scale.x /= dollyScale;
      this.object.scale.y /= dollyScale;
    };

    // Lights
    var light = new THREE.PointLight( 0xffffcc, 0.8 );
    light.position.set( 0, 50, 50 );
    this.scene.add( light );

    light = new THREE.AmbientLight( 0x404040 );
    this.scene.add( light );

    // Axes
    this.scene.add( new THREE.AxisHelper( 40 ) );

    // Grid
    var size = 1000, step = 20;

    var geometry = new THREE.Geometry();
    var material = new THREE.LineBasicMaterial( { color: 0x303030 } );

    for ( var i = - size; i <= size; i += step ) {
      geometry.vertices.push( new THREE.Vector3( - size, 0.04, i ) );
      geometry.vertices.push( new THREE.Vector3(   size, 0.04, i ) );
      geometry.vertices.push( new THREE.Vector3( i, 0.04, - size ) );
      geometry.vertices.push( new THREE.Vector3( i, 0.04,   size ) );
    }

    var line = new THREE.Line( geometry, material, THREE.LinePieces );
    this.scene.add( line );

    this.renderer.domElement.addEventListener( 'dblclick', this.mouseReact.bind(this, this.handler), false );
    // this.renderer.domElement.addEventListener( 'mousemove', this.mouseReact.bind(this, this.handler), false );

    window.addEventListener( 'resize', this.onWindowResize.bind(this), false );

    PubSub.subscribe('unit.select', this.select_handler.bind(this));
    PubSub.subscribe('unit.bubble.create', this.smartUnitBubblesUpdate.bind(this));
    PubSub.subscribe('unit.bubble.destroy', this.smartUnitBubblesUpdate.bind(this));
    PubSub.subscribe('unit.bubbles.update', this.smartUnitsCollectionBubblesUpdate.bind(this));

    this.load(model_url);
  },

  onWindowResize: function() {
    var width = this.container.clientWidth - this.options.marginWidth,
        height = window.innerHeight - this.options.marginHeight;
    this.camera.aspect = width / height; // TODO: messes up aspect
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(width, height);
  },

  // Updates bubbles for one unit it and rerenders 3d
  // @note is called on PubSub create/destroy events
  smartUnitBubblesUpdate: function(_, unit_id){
    this.bubble_handler(_, unit_id);
    this.render();
  },


  // Перерендер всех баблов
  // Вызывается в тот, момент, когда информация по баблам изменяется
  // или изменяется фильтрация по рисуемым баблам
  smartUnitsCollectionBubblesUpdate: function(){
      var unit, i, unitsCount, unitsAttrs;
      unitsAttrs = window.app.TreeInterface.getUnitsAttributes();
      for (i = 0, unitsCount = unitsAttrs.length; i < unitsCount; i++) {
          unit = unitsAttrs[i];
          this.bubble_handler(null, unit.id);
      }
      this.render()
  },




  bubble_handler: function(_, unit_id) {
    var bubbles = app.TreeInterface.getNumberOfAllBubblesForUnitAndDescendants(unit_id);
    var old_sprite = this.unit_bubbles[unit_id];
    if(old_sprite) {
      this.scene.remove(old_sprite);
    }
    var sprite = this.bubbles_sprite(bubbles);
    this.unit_bubbles[unit_id] = sprite;
  },

  selected_material: new THREE.MeshLambertMaterial( { color: 0x66ff66, transparent: true, opacity: 0.8 } ),

  select_handler: function(channel, unit_id) {
    var model_type = app.TreeInterface.getFileTypeByUnitId(unit_id);
    // в зависимости от того, какой тип контента у объекта
    // нам нужно либо нарисовать 3Д либо 2Д
    // но при отрисовке 2Д нам не нужно просить отрисовать изображение в 2Д
    if (model_type === 'volume') {
        var model_url = app.TreeInterface.getModelURLByUnitId(unit_id);
        if (model_url) {
            this.load(model_url);
            return;
        }
    }

    if (this.current_objects) {
        this.current_objects.forEach(function (object) {
            object.material = object._material;
            object.parent.material = object.parent._material;
            object.parent.parent.material = object.parent.parent._material;
        }.bind(this));
    }

    var ancestors = window.app.TreeInterface.ancestors(unit_id);
    ancestors.unshift(unit_id);

    var objects = this.intersect_objects.filter(function (candidate) {
        return ancestors.filter(function (candidate_unit_id) {
            var node_name = "node-" + candidate_unit_id;
            return candidate.name === node_name || candidate.parent.name === node_name || candidate.parent.parent.name === node_name;
        }).length > 0;
    });

    if (objects.length === 0) {
        console.log('Unable to find matching object:', unit_id);
    } else {
        objects.forEach(function (object) {
            object._material = object.material;
            object.parent._material = object.parent.material;
            object.parent.parent._material = object.parent.parent.material;
            object.material = this.selected_material;
            object.parent.material = this.selected_material;
            object.parent.parent.material = this.selected_material;
        }.bind(this));
        this.current_objects = objects;
    }

    this.render();

  },

  handler: function(object) {
    if(object.parent.name.indexOf("node-") === 0) {
      PubSub.publish('unit.select', object.parent.name.substring(5));
    } else if(object.parent.parent.name.indexOf("node-") === 0) {
      PubSub.publish('unit.select', object.parent.parent.name.substring(5));
    } else {
      console.log("Cannot find corresponding unit: ", object);
    }
  },

  render: function() {
    this.updateBubbles();
    this.renderer.render(this.scene, this.camera);
  },

  mouseReact: function(handler, event) {
    event.preventDefault();
    var canvas =  $("._three-d canvas");
    var mouse3D = new THREE.Vector3( event.offsetX / canvas.width() * 2 - 1, - event.offsetY / canvas.height() * 2 + 1, 0.5 );
    var raycaster = this.projector.pickingRay( mouse3D.clone(), this.camera );
    var intersects = raycaster.intersectObjects(this.intersect_objects);
    if(intersects.length > 0)
      handler(intersects[0].object);
  },

  updateBubbles: function() {
    for(var unit_id in this.unit_bubbles) {
      var unit_bubble = this.unit_bubbles[unit_id];
      var unit = this.dae.getObjectByName("node-"+unit_id);

      if(unit) {
        var center;
        if(unit.children[0].geometry) {
          center = unit.children[0].geometry.boundingSphere.center;
          // console.log(unit_id, unit.children[0].geometry.boundingBox.min, unit.children[0].geometry.boundingBox.max);
        } else {
          center = unit.children[0].children[0].geometry.boundingSphere.center;
          // console.log(unit_id, unit.children[0].children[0].geometry.boundingBox.min, unit.children[0].children[0].geometry.boundingBox.max);
        }

        unit_bubble.position.setX(center.x);
        unit_bubble.position.setY(10);
        unit_bubble.position.setZ(center.z);
        console.log(unit_id, center.x, center.y, center.z);
        // unit_bubble.updateMatrix();
      }
    }
  },

  // calc2DPoint: function(worldVector) {
  //   var vector = this.projector.projectVector(worldVector, this.camera);
  //   return vector;
  // }

  // готовит кругляши под баблы
  // по кругляшу на каждый тип баблов
  // на входе массив типа [2,1,4,1]
  // по нему проходимся и рисуем
  // при соглашении,что каждому порадковому номеру
  // соответствует свой цвет и важность
  //
  // если массив [2,1,null,0]
  // то бабл у которого null и 0 пропускаем в отрисовке
  bubbles_sprite: function(bubble_counts_by_type) {

    // var geometry = new THREE.BoxGeometry( 0.5, 0.5, 0.5 );
    // var material = new THREE.MeshLambertMaterial( { color: 0xbb4444 , transparent: true, opacity: 0.4 } );
    // var cube = new THREE.Mesh( geometry, material );
    // this.scene.add(cube);
    // return cube;

    var bubble_type_colors = ['red', 'blue', 'green', 'orange'];
    var font_size = 24;
    var canvas = document.createElement('canvas');
    var context = canvas.getContext('2d');
    context.font = font_size + "px Arial";

    // порядковый номер бабла, который рендерим
    // если какие-то баблы не рисуем,
    // то логично не делать пустоту на их месте,
    // а рисовать другие баблы
    var  rendered_bubble_num = 0;

    if (bubble_type_colors.length) {
        for (var type = 0; type < bubble_type_colors.length; type++) {
            // проверка на сущестование цвета
            // если цвет null, NaN, undefined, 0
            // то пропускаем шаг
            var bubble_text = bubble_counts_by_type[type];
            if (!(!bubble_text)){
                var color = bubble_type_colors[type];

                var y = 150 - (rendered_bubble_num + 0.5) * font_size * 1.5;
                context.strokeStyle = color;
                context.fillStyle = 'white';

                context.beginPath();
                if (rendered_bubble_num === 0) {
                    context.arc(150, y - font_size * 0.4, font_size * 0.6, Math.PI * 0.75, Math.PI * 2.25);
                    context.lineTo(150, y + font_size / 2);
                } else {
                    context.arc(150, y - font_size * 0.4, font_size * 0.6, 0, Math.PI * 2);
                }

                context.stroke();
                context.fill();
                var metrics = context.measureText(bubble_text);

                context.fillStyle = color;
                context.fillText(bubble_text, 150 - metrics.width / 2, y);

                // находясь в цикле рисования баблов
                // будем увеличивать номер отрендереного бабла на 1
                rendered_bubble_num++;
            }
        }
    }

    var texture = new THREE.Texture(canvas);
    texture.needsUpdate = true;

    var spriteMaterial = new THREE.SpriteMaterial({
      map: texture,
      useScreenCoordinates: false
    });

    var sprite = new THREE.Sprite( spriteMaterial );
    sprite.scale.set(50, 25, 1.0);

    this.scene.add( sprite );

    return sprite;
  }
};
