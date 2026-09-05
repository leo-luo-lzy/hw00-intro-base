import {vec3, vec4} from 'gl-matrix';
import Drawable from '../rendering/gl/Drawable';
import {gl} from '../globals';

class Cube extends Drawable {
  indices: Uint32Array;
  positions: Float32Array;
  normals: Float32Array;
  center: vec4;
  public sideLength: number;

  constructor(center: vec3, sideLength: number = 2) {
    super();
    this.center = vec4.fromValues(center[0], center[1], center[2], 1);
    this.sideLength = sideLength;
  }

  create(): void {
    const h = this.sideLength / 2;
    const cx = this.center[0];
    const cy = this.center[1];
    const cz = this.center[2];
    this.indices = new Uint32Array([
      // Front face: +Z
      0, 1, 2,
      0, 2, 3,

      // Back face: -Z
      4, 5, 6,
      4, 6, 7,

      // Right face: +X
      8, 9, 10,
      8, 10, 11,

      // Left face: -X
      12, 13, 14,
      12, 14, 15,

      // Top face: +Y
      16, 17, 18,
      16, 18, 19,

      // Bottom face: -Y
      20, 21, 22,
      20, 22, 23,
    ]);

    this.normals = new Float32Array([
      // Front face: +Z
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,

      // Back face: -Z
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,

      // Right face: +X
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,

      // Left face: -X
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,

      // Top face: +Y
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,

      // Bottom face: -Y
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
    ]);

    this.positions = new Float32Array([
      // Front face: +Z
      cx - h, cy - h, cz + h, 1,
      cx + h, cy - h, cz + h, 1,
      cx + h, cy + h, cz + h, 1,
      cx - h, cy + h, cz + h, 1,

      // Back face: -Z
      cx + h, cy - h, cz - h, 1,
      cx - h, cy - h, cz - h, 1,
      cx - h, cy + h, cz - h, 1,
      cx + h, cy + h, cz - h, 1,

      // Right face: +X
      cx + h, cy - h, cz + h, 1,
      cx + h, cy - h, cz - h, 1,
      cx + h, cy + h, cz - h, 1,
      cx + h, cy + h, cz + h, 1,

      // Left face: -X
      cx - h, cy - h, cz - h, 1,
      cx - h, cy - h, cz + h, 1,
      cx - h, cy + h, cz + h, 1,
      cx - h, cy + h, cz - h, 1,

      // Top face: +Y
      cx - h, cy + h, cz + h, 1,
      cx + h, cy + h, cz + h, 1,
      cx + h, cy + h, cz - h, 1,
      cx - h, cy + h, cz - h, 1,

      // Bottom face: -Y
      cx - h, cy - h, cz - h, 1,
      cx + h, cy - h, cz - h, 1,
      cx + h, cy - h, cz + h, 1,
      cx - h, cy - h, cz + h, 1,
    ]);
    this.generateIdx();
    this.generatePos();
    this.generateNor();

    this.count = this.indices.length;
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.bufIdx);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, this.indices, gl.STATIC_DRAW);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.bufNor);
    gl.bufferData(gl.ARRAY_BUFFER, this.normals, gl.STATIC_DRAW);

    gl.bindBuffer(gl.ARRAY_BUFFER, this.bufPos);
    gl.bufferData(gl.ARRAY_BUFFER, this.positions, gl.STATIC_DRAW);

    console.log(`Created cube`);
  }
};
export default Cube;
