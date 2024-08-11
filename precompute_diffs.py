#!/usr/bin/env python3

from math import sin, cos, radians
import sys

# precompute the screen coordinates of an 8x8 raster


def compute_screen_coords(x: int, y: int, z: int, alpha: int, beta: int) -> (int, int, int):
    screen_x = z * sin(radians(beta)) + x * cos(radians(beta))
    screen_y = x * sin(radians(beta)) * sin(radians(alpha)) + y * cos(radians(alpha)) - z * sin(radians(alpha)) * cos(radians(beta))
    screen_z = y * sin(radians(alpha)) + z * cos(radians(alpha)) * cos(radians(beta)) - x * cos(radians(alpha)) * sin(radians(beta))

    return screen_x, screen_y, screen_z

if __name__ == '__main__':
    print("; this file is generated using precompute_diffs.py")
    xmult = 1.8
    ymult = 1
    zmult = 1.1
    xoffset = 160
    yoffset = 120
    zoffset = 64
    alphas = (20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,105,110,115,120,125,130,135,140,145,150,155,160,165,170,175,180) # 6
    betas = (0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,105,110,115,120,125,130,135,140,145,150,155,160,165,170,175,180) # 37
    bytes_per_diff = 24
    min_screen_z = 500
    max_screen_z = 0
    print(f"bytes_per_diff equ {bytes_per_diff}")
    print(f"diffs_per_alpha equ {len(betas)}")
    print(f"bytes_per_alpha equ {len(betas)*bytes_per_diff}")
    for alpha in alphas:
        for beta in betas:
            print(f"; alpha = {alpha} beta = {beta}")
            # xdiff (1 step in x direction)
            xcoord = -31
            ycoord = -31
            zcoord = -31
            sx,sy,sz = compute_screen_coords(xcoord, ycoord, zcoord, alpha, beta)
            print("; lower left front coordinates")
            print(f"    dc.w {round(sx * xmult + xoffset)},{round(sy * ymult + yoffset)},{round(sz * zmult + zoffset)}")
            max_screen_z = max(round(sz * zmult + zoffset), max_screen_z)
            min_screen_z = min(round(sz * zmult + zoffset), min_screen_z)

            xcoord = -22
            ycoord = -31
            zcoord = -31
            nx,ny,nz = compute_screen_coords(xcoord, ycoord, zcoord, alpha, beta)

            dx,dy,dz = nx-sx,ny-sy,nz-sz
            print("; diff x")
            print(f"    dc.w {round(dx * xmult)},{round(dy * ymult)},{round(dz * zmult)}")
            max_screen_z = max(round(sz * zmult + zoffset) + 7*round(dz*zmult), max_screen_z)
            min_screen_z = min(round(sz * zmult + zoffset) + 7*round(dz*zmult), min_screen_z)

            xcoord = -31
            ycoord = -22
            zcoord = -31
            nx,ny,nz = compute_screen_coords(xcoord, ycoord, zcoord, alpha, beta)

            dx,dy,dz = nx-sx,ny-sy,nz-sz
            print("; diff y")
            print(f"    dc.w {round(dx * xmult)},{round(dy * ymult)},{round(dz * zmult)}")
            max_screen_z = max(round(sz * zmult + zoffset) + 7*round(dz*zmult), max_screen_z)
            min_screen_z = min(round(sz * zmult + zoffset) + 7*round(dz*zmult), min_screen_z)

            xcoord = -31
            ycoord = -31
            zcoord = -22
            nx,ny,nz = compute_screen_coords(xcoord, ycoord, zcoord, alpha, beta)

            dx,dy,dz = nx-sx,ny-sy,nz-sz
            print("; diff z")
            print(f"    dc.w {round(dx * xmult)},{round(dy * ymult)},{round(dz * zmult)}")
            max_screen_z = max(round(sz * zmult + zoffset) + 7*round(dz*zmult), max_screen_z)
            min_screen_z = min(round(sz * zmult + zoffset) + 7*round(dz*zmult), min_screen_z)
            # print("    dc.w 0,0,0,0 ; filler to make the step 32 bytes")
    print(f"; min z={min_screen_z}, max z={max_screen_z}")
