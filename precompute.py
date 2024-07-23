#!/usr/bin/env python3

from math import sin, cos, radians

# precompute the screen coordinates of an 8x8 raster


def compute_screen_coords(x: int, y: int, z: int, alpha: int, beta: int) -> (int, int, int):
    screen_x = z * sin(radians(beta)) + x * cos(radians(beta))
    screen_y = x * sin(radians(beta)) * sin(radians(alpha)) + y * cos(radians(alpha)) - z * sin(radians(alpha)) * cos(radians(beta))
    screen_z = y * sin(radians(alpha)) + z * cos(radians(alpha)) * cos(radians(beta)) - x * cos(radians(alpha)) * sin(radians(beta))

    return screen_x, screen_y, screen_z

if __name__ == '__main__':
    xmult = 2
    ymult = 2
    zmult = 1
    xoffset = 0
    yoffset = 0
    zoffset = 0
    for alpha in (0,15,30,45,60,75):
        for beta in (0,15,30,45,60,75):
            print(f"; alpha = {alpha} beta = {beta}")
            # xdiff (1 step in x direction)
            xcoord = -31
            ycoord = -31
            zcoord = -31
            sx,sy,sz = compute_screen_coords(xcoord, ycoord, zcoord, alpha, beta)

            xcoord = -22
            ycoord = -31
            zcoord = -31
            nx,ny,nz = compute_screen_coords(xcoord, ycoord, zcoord, alpha, beta)

            dx,dy,dz = nx-sx,ny-sy,nz-sz
            print("; diff x")
            print(f"    dc.w {round(dx * xmult + xoffset)},{round(dy * ymult + yoffset)},{round(dz * zmult + zoffset)}")

            xcoord = -31
            ycoord = -22
            zcoord = -31
            nx,ny,nz = compute_screen_coords(xcoord, ycoord, zcoord, alpha, beta)

            dx,dy,dz = nx-sx,ny-sy,nz-sz
            print("; diff y")
            print(f"    dc.w {round(dx * xmult + xoffset)},{round(dy * ymult + yoffset)},{round(dz * zmult + zoffset)}")

            xcoord = -31
            ycoord = -31
            zcoord = -22
            nx,ny,nz = compute_screen_coords(xcoord, ycoord, zcoord, alpha, beta)

            dx,dy,dz = nx-sx,ny-sy,nz-sz
            print("; diff z")
            print(f"    dc.w {round(dx * xmult + xoffset)},{round(dy * ymult + yoffset)},{round(dz * zmult + zoffset)}")


    #coords = [-31, -22, -13, -4, 5, 14, 23, 32]
    #for x in coords:
    #    for y in coords:
    #        compute_screen_coords(x,y,0,0,0)
