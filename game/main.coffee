#'use strict'

Physijs.scripts.worker = 'library/physijs_worker.js'
Physijs.scripts.ammo = 'ammo.js'

projector = new THREE.Projector()
renderer = new THREE.WebGLRenderer()
scene = new Physijs.Scene()
camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 2500)

manatee = new Physijs.SphereMesh(
  new THREE.SphereGeometry(10, 10, 10),
  Physijs.createMaterial(new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture('images/manatee.jpg') }), .4, .6)
)

initScene = =>
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer.shadowMapEnabled = false
  document.getElementById('viewport').appendChild(renderer.domElement)

  scene.setGravity(new THREE.Vector3(0, -100, 0))

  camera.position.set(200, 50, 0)
  camera.lookAt(manatee.position)
  scene.add(camera)

  light = new THREE.DirectionalLight(0xFFDDFE)
  light.position.set(20, 40, -15)
  light.target.position.copy(scene.position)
  scene.add(light)

  ground = new Physijs.BoxMesh(new THREE.CubeGeometry(10000, 1, 2000), Physijs.createMaterial(
    new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture('images/ground.png') }), .8, .4
  ), 0)
  scene.add(ground)

  manatee.position.set(-500, 20, 0)
  manatee.scale.set(1, 1, 1)
  manatee.castShadow = true
  scene.add(manatee)

  @window.addEventListener 'deviceorientation', (e) -> manatee.applyCentralImpulse({ z: e.gamma * -1000, y: 0, x: 2500 })
  scene.addEventListener('update', -> camera.position.set(manatee.position.x + 750, 75, 0))

  requestAnimationFrame(render)

render = ->
  renderer.render(scene, camera)
  scene.simulate(undefined, 0)
  requestAnimationFrame(render)

window.onload = initScene()
