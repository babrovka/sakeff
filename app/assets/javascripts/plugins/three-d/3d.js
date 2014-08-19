window.addEventListener('load', function() {
  new ThreeDee('._three-d', {
    marginHeight: 200
  });
});

function makeTextSprite( message, parameters ) {
  var fontface = parameters.hasOwnProperty("fontface") ? parameters.fontface : "Arial";
  var fontsize = parameters.hasOwnProperty("fontsize") ? parameters.fontsize : 18;
  var borderThickness = parameters.hasOwnProperty("borderThickness") ? parameters.borderThickness : 0;
  var borderColor = parameters.hasOwnProperty("borderColor") ? parameters.borderColor : { r:0, g:0, b:0, a:1.0 };
  var backgroundColor = parameters.hasOwnProperty("backgroundColor") ? parameters.backgroundColor : { r:255, g:255, b:255, a:1.0 };

  var canvas = document.createElement('canvas');
  var context = canvas.getContext('2d');
  context.font = fontsize + "px " + fontface;

  // get size data (height depends only on font size)
  var metrics = context.measureText( message );
  var textWidth = metrics.width;

  // background color
  context.fillStyle   = "rgba(" + backgroundColor.r + "," + backgroundColor.g + "," + backgroundColor.b + "," + backgroundColor.a + ")";
  // border color
  context.strokeStyle = "rgba(" + borderColor.r + "," + borderColor.g + "," + borderColor.b + "," + borderColor.a + ")";

  context.lineWidth = borderThickness;
  roundRect(context, borderThickness/2, borderThickness/2, textWidth + borderThickness, fontsize * 1.4 + borderThickness, 6);
  // 1.4 is extra height factor for text below baseline: g,j,p,q.

  // text color
  context.fillStyle = "rgba(0, 0, 0, 1.0)";
  context.fillText( message, borderThickness, fontsize + borderThickness);

  // canvas contents will be used for a texture
  var texture = new THREE.Texture(canvas);
    texture.needsUpdate = true;

  var spriteMaterial = new THREE.SpriteMaterial(
      { map: texture,
        useScreenCoordinates: true
      });

  var sprite = new THREE.Sprite( spriteMaterial );
  sprite.scale.set(10, 5, 1.0);
  return sprite;
}

// function for drawing rounded rectangles
function roundRect(ctx, x, y, w, h, r) {
  ctx.beginPath();
  ctx.moveTo(x+r, y);
  ctx.lineTo(x+w-r, y);
  ctx.quadraticCurveTo(x+w, y, x+w, y+r);
  ctx.lineTo(x+w, y+h-r);
  ctx.quadraticCurveTo(x+w, y+h, x+w-r, y+h);
  ctx.lineTo(x+r, y+h);
  ctx.quadraticCurveTo(x, y+h, x, y+h-r);
  ctx.lineTo(x, y+r);
  ctx.quadraticCurveTo(x, y, x+r, y);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();
}

var ThreeDee = function(selector, options) {
  this.selector = selector;
  this.options = options;
  this.load();
};

ThreeDee.prototype = {
  load: function() {
    // if ( ! Detector.webgl ) Detector.addGetWebGLMessage();

    var loader = new THREE.ColladaLoader();
    loader.options.convertUpAxis = true;
    loader.load( '/models/buildings2.dae', function ( collada ) {
      this.dae = collada.scene;
      // this.dae.scale.x = this.dae.scale.y = this.dae.scale.z = 0.5;
      // this.dae.position.x = -10;
      // this.dae.position.z = 10;
      this.dae.updateMatrix();
      this.deepComputeBoundingBoxAndSphere(this.dae);
      this.init();
    }.bind(this));

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
    this.intersect_objects = this.dae.children.map(function(object) { return object.children[0]; });
    this.intersect_objects.forEach(function(object){ object.material = this.normal_material; }, this);

    this.renderer.domElement.addEventListener( 'dblclick', this.mouseReact.bind(this, this.handler), false );
    // this.renderer.domElement.addEventListener( 'mousemove', this.mouseReact.bind(this, this.handler), false );

    window.addEventListener( 'resize', this.onWindowResize.bind(this), false );

    PubSub.subscribe('Selected objects', this.select_handler.bind(this));

    this.render(true);

    var balloons_mock = [
      { object_id: 'sarai', text: 'sldkjfsldf', type: 1},
      { object_id: 'warehouse', text: 'slfjd', type: 2},
      { object_id: 'warehouse', text: 'pqojdpwojd', type: 3},
      { object_id: 'angle', text: 'asfj-j-0 osdjfoasjdfi', type: 4},
      { object_id: 'wall', text: 's', type: 3},
      { object_id: 'wall', text: '-text9 -9hsd-v', type: 4},
      { object_id: 'building', text: 'a-w0u 0 a 9u-0a ', type: 3},
      { object_id: 'pyramid', text: 'q-=a0u a=a 0=', type: 1},
      { object_id: 'pyramid', text: '-aa- -0a i0i', type: 4},
      { object_id: 'pyramid', text: 'o lasj aslk', type: 2}
    ];

    this.balloons = balloons_mock.map(function(balloon) {
      var sprite = makeTextSprite( balloon.text, { fontsize: 32, backgroundColor: {r:255, g:100, b:100, a:1} } );
      this.scene.add( sprite );

      return { object_id: balloon.object_id, node: sprite };
    }, this);

    this.updateBalloons();
  },

  balloonTypeColors: ['cyan', 'blue', 'yellow', 'red'],

  onWindowResize: function() {
    var width = this.container.clientWidth,
        height = window.innerHeight - this.options.marginHeight;
    this.camera.aspect = width / height;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(width, height);
  },

  alerted_material: new THREE.MeshLambertMaterial( { color: 0xbb4444 , transparent: true, opacity: 0.8 } ),
  normal_material: new THREE.MeshLambertMaterial( { color: 0xaaaaaa  , transparent: true, opacity: 0.8 } ),
  selected_material: new THREE.MeshLambertMaterial( { color: 0x88cc88, transparent: true, opacity: 0.8 } ),

  select_handler: function(channel, message) {
    console.log('selected', message);

    if(this.current_object) {
      if(this.current_object.state === true) {
        this.current_object.material = this.alerted_material;
      } else {
        this.current_object.material = this.normal_material;
      }
    }

    var objects = this.intersect_objects.filter(function(candidate) { return candidate.uuid === message; });

    if(objects.length === 0) {
      console.log('unable to find matching object');
    } else {
      var object = objects[0];
      object.material = this.selected_material;
      this.current_object = object;
    }

    this.render();
  },

  handler: function(object) {
    PubSub.publish('Selected objects', object.uuid);
  },

  render: function(doNotUpdateBalloons) {
    this.renderer.render(this.scene, this.camera);
    if(!doNotUpdateBalloons) this.updateBalloons();
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

  updateBalloons: function() {
    this.balloons.forEach( function(balloon) {
      var object = this.dae.getObjectById(balloon.object_id);// WTF? doesn't seem to find neither by id nor uuid (both seem to be dynamic in OBJloader, and name seems to be the only constant)

      if(object) {
        var center = object.children[0].geometry.boundingSphere.center;
        balloon.node.position.x = center.x/45;
        balloon.node.position.y = 5;
        balloon.node.position.z = center.z/45;
      }
    }.bind(this));
  },

  // calc2DPoint: function(worldVector) {
  //   var vector = this.projector.projectVector(worldVector, this.camera);
  //   return vector;
  // }
};
