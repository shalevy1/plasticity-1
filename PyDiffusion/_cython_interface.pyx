"""Module for code intended to be used from MATLAB.

The goal is to hide all Python OOP and just use data (i.e.
floats, ints, matrices) that both languages (and C) shared
happily.
"""

import itertools
import numpy as np
cimport cython
from cython cimport view

from particle_diffusion_on_mesh import Mesh
from particle_diffusion_on_mesh import Point


@cython.boundscheck(False)
@cython.wraparound(False)
def advance_one_step(double[:, ::1] xyz_loc, long[:, ::1] face_indices,
                     double k, double[::1] initial_point,
                     long initial_face_index, double[:, ::1] all_vertices,
                     long[:, ::1] triangles, double[:, ::1] face_local_bases,
                     long[:, ::1] neighbor_faces):
    """Custom method for advancing simulation by one-step.

    This is a bare-bones method which accepts and returns only simple types
    (matrices) to avoid surfacing Python OOP in it's interface.

    The main values being advanced are the points and faces corresponding to
    those points. In addition, the remaining (7) arguments are used to
    construct a `Mesh` object.

    Args:
        xyz_loc: An Mx3 array (2D) of point locations.
        face_indices: An Mx1 vector (2D so MATLAB is happy) of face indices
                      corresponding to each point in `xyz_loc`.
        k: Float, the "global" diffusion rate in the mesh.
        initial_point: A 3-vector (1D) of floats containing the initial starting
                       point on the mesh.
        initial_face_index: Integer. The face containing `initial_point`.
        all_vertices: A Vx3 matrix of floats containing all the vertices in
                      the mesh.
        triangles: A Tx3 matrix of integers containing the vertex indices of
                   each triple of vertices in a mesh triangle exterior face.
        face_local_bases: A Tx6 matrix of floats containing a pre-computed
                          orthogonal basis of the plane going through each
                          triangle. (The rows of `face_local_bases` correspond
                          to the rows of `triangles`).
        neighbor_faces: A Tx3 matrix of integers containing indices of the
                        neighbors of each face in `triangles`. A triangle has 3
                        sides hence 3 neighbors. (The rows of `neighbor_faces`
                        correspond to the rows of `triangles`).

    Returns:
        Returns two arrays, the updated version of xyz_loc and face_indices.
    """
    mesh_wrapper = Mesh(k, np.asarray(initial_point), initial_face_index,
                        np.asarray(all_vertices), np.asarray(triangles),
                        np.asarray(face_local_bases),
                        np.asarray(neighbor_faces))
    # NOTE: We assume but don't check that xyz_loc and face_indices
    #       have the same number of rows.
    points = []
    for pt, face_index in itertools.izip(xyz_loc, face_indices):
        face_index, = face_index  # Unpacking a row of an Mx1 matrix.
        points.append(Point(mesh_wrapper, point=pt, face_index=face_index))

    # After all points are set, we are OK to move them.
    for pt in points:
        pt.move()

    cdef int i
    for i, pt in enumerate(points):
        # Update the xyz locations in place.
        xyz_loc[i, 0] = pt.point[0]
        xyz_loc[i, 1] = pt.point[1]
        xyz_loc[i, 2] = pt.point[2]
        # Update the face indices in place.
        face_indices[i, 0] = pt.face.face_index


cdef public void advance_one_step_c(
        int num_points, int num_vertices, int num_triangles,
        double* xyz_loc, long* face_indices, double k, double* initial_point,
        long initial_face_index, double* all_vertices,
        long* triangles, double* face_local_bases, long* neighbor_faces):
    cdef view.array py_face_indices = <long[:num_points, :1]> face_indices
    cdef view.array py_xyz_loc = <double[:num_points, :3]> xyz_loc
    cdef view.array py_initial_point = <double[:3]> initial_point
    cdef view.array py_all_vertices = <double[:num_vertices, :3]> all_vertices
    cdef view.array py_triangles = <long[:num_triangles, :3]> triangles
    cdef view.array py_face_local_bases = \
        <double[:num_triangles, :6]> face_local_bases
    cdef view.array py_neighbor_faces = \
        <long[:num_triangles, :3]> neighbor_faces
    advance_one_step(py_xyz_loc, py_face_indices, k, py_initial_point,
                     initial_face_index, py_all_vertices, py_triangles,
                     py_face_local_bases, py_neighbor_faces)