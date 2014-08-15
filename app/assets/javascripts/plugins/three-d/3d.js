// cbrwizard todo suggestions:
// Also, make container change its width+aspect on window resize
// Also, make the container height equals page height minus a constant from options

window.addEventListener('load', function() {
  new ThreeDee('._three-d');
});

var ThreeDee = function(selector) {
  this.selector = selector;
  this.load();
};

ThreeDee.prototype = {
  load: function() {
    if ( ! Detector.webgl ) Detector.addGetWebGLMessage();

    var loader = new THREE.ColladaLoader();
    loader.options.convertUpAxis = true;
    var self = this;
    loader.load( '/models/buildings2.dae', function ( collada ) {
      self.dae = collada.scene;
      self.dae.scale.x = self.dae.scale.y = self.dae.scale.z = 0.5;
      self.dae.position.x = -10; self.dae.position.z = 10;
      self.dae.updateMatrix();
      self.deepComputeBoundingBox(self.dae);
      self.init();
    });

    // var loader = new THREE.OBJLoader();
    // loader.load( '/models/damba_simple_v3.obj', function ( obj ) {
    //   dae = obj;
    //   dae.scale.x = dae.scale.y = dae.scale.z = 0.1;
    //   dae.rotation.x = Math.PI/2;
    //   dae.updateMatrix();
    //   self.init();
    //   self.render();
    // });
  },

  deepComputeBoundingBox: function(object) {
    object.children.forEach(this.deepComputeBoundingBox, this);
    if(object.geometry) object.geometry.computeBoundingBox();
  },

  // var balloons = []

  init: function() {
    var domContainer =  $(this.selector);
    this.container = domContainer[0];

    this.renderer = new THREE.WebGLRenderer();
    // Should be controlled by CSS, not JS
    this.container.width = Math.max(this.container.innerWidth, 300);
    this.container.height = Math.max(this.container.innerHeight, 300);

    this.renderer.setSize(this.container.innerWidth, this.container.innerHeight);

    this.projector = new THREE.Projector();

    var aspect = window.innerWidth / window.innerHeight;
    var d = 20;
    this.camera = new THREE.OrthographicCamera( - d * aspect, d * aspect, d, - d, 1, 1000 );
    this.camera.position.set( 17.32, 14.14, 17.32 );
    this.camera.rotation.y = Math.PI / 3;
    this.camera.rotation.x = Math.atan( - 1 / Math.sqrt( 2 ) );

    this.scene = new THREE.Scene();

    // Add the COLLADA
    this.scene.add( this.dae );

    var self = this;
    var render_handler = function() { self.render(self.renderer, self.scene, self.camera); };
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
    // this.scene.add( new THREE.AxisHelper( 40 ) );

    // Ground
    var plane_geometry = new THREE.PlaneGeometry( 100, 100 );
    var plane_material = new THREE.MeshBasicMaterial( {color: 0x6666aa, side: THREE.DoubleSide} );
    var ground = new THREE.Mesh(plane_geometry, plane_material);
    ground.rotation.x = Math.PI / 2;
    this.scene.add(ground);

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

    this.container.appendChild( this.renderer.domElement );

    this.intersect_objects = this.dae.children.map(function(object) { return object.children[0]; });

    this.container.addEventListener( 'dblclick', this.mouseReact(this.handler), false );
    // container.addEventListener( 'mousemove', this.mouseReact(this.handler), false );

    this.render(this.renderer, this.scene, this.camera);
  },

  alerted_material: new THREE.MeshLambertMaterial( { color: 0xbb4444 } ),
  normal_material: new THREE.MeshLambertMaterial( { color: 0xaaaaaa } ),
  selected_material: new THREE.MeshLambertMaterial( { color: 0x88cc88 } ),

  handler: function(self, object) {
    if(self.current_object) {
      if(self.current_object.state === true) {
        self.current_object.material = self.alerted_material;
      } else {
        self.current_object.material = self.normal_material;
      }
    }

    object.material = self.selected_material;
    self.current_object = object;

    self.render(self.renderer, self.scene, self.camera);
  },

  render: function(renderer, scene, camera) {
    renderer.render(scene, camera);
    // this.updateBalloons();
  },

  mouseReact: function(handler) {
    var self = this;
    return function(event) {
      event.preventDefault();
      var canvas =  $("._three-d canvas");
      var mouse3D = new THREE.Vector3( event.offsetX / canvas.width() * 2 - 1, - event.offsetY / canvas.height() * 2 + 1, 0.5 );
      var raycaster = self.projector.pickingRay( mouse3D.clone(), self.camera );
      var intersects = raycaster.intersectObjects(self.intersect_objects);
      if(intersects.length > 0)
        handler(self, intersects[0].object);
    };
  },

  updateBalloons: function() {
    // balloons.forEach(updateBalloon);
  },

  updateBalloon: function(balloon) {
    var object = this.dae.getObjectById(balloon.object_id);
    if(object) {
      var on_screen = calc2DPoint(object.children[0].geometry.boundingBox.max);
      // console.log(object.children[0].geometry.boundingBox.max);

      balloon.style.left = on_screen.x + 'px';
      balloon.style.top = on_screen.y + 'px';
    }
  },

  calc2DPoint: function(worldVector) {
    var vector = this.projector.projectVector(worldVector, this.camera);
    var halfWidth = this.renderer.domElement.width / 2;
    var halfHeight = this.renderer.domElement.height / 2;
    return {
      x: Math.round(vector.x * halfWidth + halfWidth),
      y: Math.round(-vector.y * halfHeight + halfHeight)
    };
  }
};
