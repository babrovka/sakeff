// =require 'models/units'
// =require 'models/bubbles'

var ThreeDee = function(selector, options) {
  this.selector = selector;
  this.options = options;
  this.load();
};

ThreeDee.prototype = {
  load_indicator: function(progress) {
    $(this.selector).text( Math.round(progress.loaded / progress.total*100) + '%' );
  },

  load: function() {
    // if ( ! Detector.webgl ) Detector.addGetWebGLMessage();

    var loader = new THREE.ColladaLoader();
    loader.options.convertUpAxis = true;
    loader.load( '/models/kvadrat 15-7rescale2.dae', function ( collada ) {
      this.dae = collada.scene;
      this.dae.scale.x = this.dae.scale.y = this.dae.scale.z = 20;
      // this.dae.position.x = -10;
      // this.dae.position.z = 10;
      // this.dae.updateMatrix();
      this.deepComputeBoundingBoxAndSphere(this.dae);
      this.dae.children = this.dae.children.filter(function(child) { return child.id.indexOf("node-") === 0 || child.id.indexOf("land") === 0; }); // Only load those nodes starting with 'node-'
      $(this.selector).text('');
      this.init();
    }.bind(this), this.load_indicator.bind(this));

    // var loader = new THREE.OBJLoader();
    // loader.load( '/models/kvadrat 15-7.obj', function ( obj ) {
    //   this.dae = obj;
    //   this.dae.scale.x = this.dae.scale.y = this.dae.scale.z = 10;
    //   this.dae.rotation.x = -Math.PI/2;
    //   this.dae.position.y = -4.5;
    //   this.dae.updateMatrix();
    //   this.deepComputeBoundingBoxAndSphere(this.dae);
    //   this.init();
    // }.bind(this));
  },

  deepComputeBoundingBoxAndSphere: function(object) {
    object.children.forEach(this.deepComputeBoundingBoxAndSphere, this);
    if(object.geometry) {
      object.geometry.computeBoundingBox();
      object.geometry.computeBoundingSphere();
    }
  },

  init: function() {
    this.container = $(this.selector)[0];
    var width = this.container.clientWidth,
        height = window.innerHeight - this.options.marginHeight;

    if ( Detector.webgl )
      this.renderer = new THREE.WebGLRenderer( {antialias:true} );
    else
      this.renderer = new THREE.CanvasRenderer();

    this.renderer.autoUpdateObjects = false;
    this.renderer.setSize(width, height);

    this.container.appendChild( this.renderer.domElement );

    this.projector = new THREE.Projector();

    var aspect = width / height;
    var d = 20;
    this.camera = new THREE.OrthographicCamera( - d * aspect, d * aspect, d, - d, -1000, 1000 );
    this.camera.position.set( 17.32, 14.14, 17.32 );
    this.camera.rotation.y = Math.PI / 3;
    this.camera.rotation.x = 0;

    // this.camera = new THREE.PerspectiveCamera( 30, aspect, 0.1, 20000);
    // this.camera.position.set(0,150,400);

    this.scene = new THREE.Scene();

    this.camera.lookAt(this.scene.position);

    // Add the COLLADA
    this.scene.add( this.dae );

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
    var light = new THREE.PointLight( 0xffffff, 0.8 );
    light.position.set( 0, 50, 50 );
    this.scene.add( light );

    light = new THREE.AmbientLight( 0x404040 );
    this.scene.add( light );

    // Axes
    this.scene.add( new THREE.AxisHelper( 40 ) );

    // Grid
    var size = 100, step = 2;

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

    // this.intersect_objects = this.dae.children; //.map(function(object) { return object.children[0]; });
    this.intersect_objects = this.dae.children.filter(function(child) { return child.id.indexOf("node-") === 0; })
      .map(function(object) { return object.children[0]; });
    this.intersect_objects.forEach(function(object){ object.material = this.normal_material; }, this);
    this.dae.children.filter(function(child) { return child.id.indexOf("land") === 0; })
      .forEach(function(object){ object.material = this.land_material; }, this);

    this.renderer.domElement.addEventListener( 'dblclick', this.mouseReact.bind(this, this.handler), false );
    // this.renderer.domElement.addEventListener( 'mousemove', this.mouseReact.bind(this, this.handler), false );

    window.addEventListener( 'resize', this.onWindowResize.bind(this), false );

    PubSub.subscribe('unit.select', this.select_handler.bind(this));
    PubSub.subscribe('unit.bubble.create', this.select_handler.bind(this));
    PubSub.subscribe('unit.bubble.destroy', this.select_handler.bind(this));
    PubSub.subscribe('unit.bubble.update', this.select_handler.bind(this));

    // TODO: remove mock; put unit_bubbles init into bubble sync callback
    var bubble_mock = [ { unit_id: '1256fc2e-939f-424e-87ff-5054bd5c6053', bubbles: [ 5, 2, 6, 0 ] } ];

    this.unit_bubbles = bubble_mock.map(function(unit) {
      return { unit_id: unit.unit_id, bubbles: this.bubbles_sprite(unit.bubbles) };
    }, this);

    this.render();
  },

  onWindowResize: function() {
    var width = this.container.clientWidth,
        height = window.innerHeight - this.options.marginHeight;
    this.camera.aspect = width / height;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(width, height);
  },

  alerted_material: new THREE.MeshLambertMaterial( { color: 0xbb4444 , transparent: true, opacity: 0.8 } ),
  normal_material: new THREE.MeshLambertMaterial( { color: 0xaaaaaa  }),
  selected_material: new THREE.MeshLambertMaterial( { color: 0x88cc88, transparent: true, opacity: 0.8 } ),
  land_material: new THREE.MeshLambertMaterial( { color: 0x22aa22, transparent: true, opacity: 0.8 } ),

  select_handler: function(channel, unit_id) {
    if(this.current_object) {
      if(this.current_object.state === true) {
        this.current_object.material = this.alerted_material;
      } else {
        this.current_object.material = this.normal_material;
      }
    }

    // TODO: replace with find: (ECMA6 polyfill)
    // var unit = window.models.units.find(function(unit) {return unit.get('id') === unit_id; });
    var all_ancestors = function(ancestors, unit_id) {
      var unit = window.models.units.filter(function(unit) { return unit.get('id') === unit_id; })[0];
      var parent_id = unit.get('parent');
      ancestors.push(unit_id);
      return parent_id === '#' ? ancestors : all_ancestors(ancestors, parent_id);
    };

    var ancestors = all_ancestors([], unit_id);

    // TODO: replace with find
    var objects = this.intersect_objects.filter(function(candidate) {
      return ancestors.filter(function(candidate_unit_id) {
        var node_name = "node-" + candidate_unit_id;
        return candidate.parent.name === node_name;
      }).length > 0;
    });

    if(objects.length === 0) {
      console.log('unable to find matching object:', unit_id);
    } else {
      var object = objects[0];
      object.material = this.selected_material;
      this.current_object = object;
    }

    this.render();
  },

  handler: function(object) {
    PubSub.publish('unit.select', object.parent.id.substring(5));
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
    this.unit_bubbles.forEach(function(unit_bubble) {
      var unit = this.dae.getObjectById("node-"+unit_bubble.unit_id);// WTF? doesn't seem to find neither by id nor uuid (both seem to be dynamic in OBJloader, and name seems to be the only constant)

      if(unit) {
        var center = unit.children[0].geometry.boundingSphere.center;
        unit_bubble.bubbles.position.setX(- center.y/45);
        unit_bubble.bubbles.position.setY(1);
        unit_bubble.bubbles.position.setZ(center.z/45);
        // unit_bubble.bubbles.updateMatrix();
      }
    }, this);
  },

  // calc2DPoint: function(worldVector) {
  //   var vector = this.projector.projectVector(worldVector, this.camera);
  //   return vector;
  // }

  bubbles_sprite: function(bubble_counts_by_type) {

    // var geometry = new THREE.BoxGeometry( 0.5, 0.5, 0.5 );
    // var material = new THREE.MeshLambertMaterial( { color: 0xbb4444 , transparent: true, opacity: 0.4 } );
    // var cube = new THREE.Mesh( geometry, material );
    // this.scene.add(cube);
    // nodes.push({node: cube, type: 0});

    var bubble_type_colors = ['green', 'blue', 'yellow', 'red'];

    var font_size = 36, margin = 12;

    var canvas = document.createElement('canvas');
    var context = canvas.getContext('2d');
    context.font = font_size + "px Arial";


    for(var type = 0; type < 4; type++) {
      var color = bubble_type_colors[type];
      var text = bubble_counts_by_type[type];

      var metrics = context.measureText(text);
      var text_width = metrics.width + 2 * margin;

      context.fillStyle = color;
      context.fillText(text, font_size + margin, ( 1+ type ) * font_size);
    }

    var texture = new THREE.Texture(canvas);
    texture.needsUpdate = true;

    var spriteMaterial = new THREE.SpriteMaterial({
      map: texture,
      useScreenCoordinates: false
    });

    var sprite = new THREE.Sprite( spriteMaterial );
    sprite.scale.set(10, 5, 1.0);

    this.scene.add( sprite );

    return sprite;
  }
};
